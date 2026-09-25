# Implementing patterns in Camel

First it is necessary to create a main class that will be the class used to
upload the entire application with Spring Boot, it is called
**DemoCamelParallelApplication.java** and is annotated with
**@SpringBootApplication** this annotation tells Spring Boot that this class
should be used as a base to configure our entire application would be a
combination of some annotations used by Spring to configure an application.

``` { .java .copy }
package br.com.santander.xpto.integracao.parallel;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/** Main class for the Spring Boot application. */
@SpringBootApplication
public class DemoCamelParallelApplication {

    /**
     * Main method for initializing the Spring Boot application.
     *
     * @param args execution arguments.
     */
    public static void main(String[] args) {
        SpringApplication.run(DemoCamelParallelApplication.class, args);
    }
}
```

The route is a crucial part of Apache Camel, where the flow and logic of an
integration is specified. Routes need to extend the RouteBuilder class and
override the configure method.

We are exposing a rest endpoint on the first route, the second route is
responsible for decomposing the json list, sending the backend route and
grouping the responses. The third route is responsible for the http call to the
backend.

For the split process to be done with performance, it is necessary to use an
ExecutorService, which manages executions in parallel, creating a pool of
threads, starting and canceling executions. The default value for poolSize is 20
and for maxPoolSize is 50, these values must be adjusted so that there are no
processing restriction points.

Another necessary adjustment is the suitability of the maxTotalConnections and
connectionsPerRoute parameters, which have default values of 200 and 20, values
not suitable for parallel processing of large volumes.

``` { .java .copy }
package br.com.santander.xpto.integracao.parallel;

import java.util.concurrent.ExecutorService;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.builder.ThreadPoolBuilder;
import org.springframework.stereotype.Component;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.apache.camel.model.rest.RestBindingMode;

/** Component responsible for configure routes. */
@Component
public class ParallelRouteBuilder extends RouteBuilder {

    /**
     * Method responsible for configure routes.
     */
    @Override
    public void configure() throws Exception {

        // Thread pool definition to use in split process
        //
        ThreadPoolBuilder builder = new ThreadPoolBuilder(getContext());
        ExecutorService poolSplitter = builder.poolSize(400).maxPoolSize(400).build("poolSplitter");

        // REST endpoint configuration
        restConfiguration().host("localhost").port(8080).bindingMode(RestBindingMode.auto).contextPath("/");

        // REST route definition
        rest("/ibpj")
            .consumes("application/json")
            .produces("application/json")
            .post("/calc")
                .to("direct:split");

        // Split and aggregation route definition
        from("direct:split")
            .split()
                .jsonpathWriteAsString("$") // Split json list
                .aggregationStrategy(new ParallelAggregationStrategy()) // Set aggregation method
                .parallelProcessing().executorService(poolSplitter) // Configure the thread pool for parallel processing
                    .to("direct:backend"); // Call backend route

        // Backend call route definition
        from("direct:backend")
            // Call backend using http4 protocol
            .to("http4://localhost:8090/itens?bridgeEndpoint=true&maxTotalConnections=1000&connectionsPerRoute=200")
            // Convert response to a pojo class
            .unmarshal().json(JsonLibrary.Jackson, Item.class);
    }
}
```

The message grouping logic is handled by the class below, it is triggered at
each message return and keeps the data grouped in a list.

``` { .java .copy }
package br.com.santander.xpto.integracao.parallel;

import java.util.ArrayList;

import org.apache.camel.AggregationStrategy;
import org.apache.camel.Exchange;

/** Class responsible for implement the aggregation strategy. */
public class ParallelAggregationStrategy implements AggregationStrategy {

  /**
   * Method responsible for implement the aggregation logic.
   * @return message container.
   */
    public Exchange aggregate(Exchange oldExchange, Exchange newExchange) {

        // Get the message from body, the newExchange has the splitted response item
        Item newBody = newExchange.getMessage().getBody(Item.class);

        ArrayList<Item> list = null;

        // First time, oldExchange is null, need to create the array to store all aggregated itens
        if (oldExchange == null) {

            list = new ArrayList<Item>();
            list.add(newBody);

            newExchange.getIn().setBody(list);

            // Always return a list that contains all response itens
            return newExchange;
        } else {

            list = oldExchange.getMessage().getBody(ArrayList.class);
            list.add(newBody);

            // Always return a list that contains all response itens
            return oldExchange;
        }
    }
}
```
