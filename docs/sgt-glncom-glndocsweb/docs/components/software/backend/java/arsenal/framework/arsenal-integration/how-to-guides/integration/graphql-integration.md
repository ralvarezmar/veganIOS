# Implementation GraphQL Integration

## Dependency

We are using camel's graphql component in conjunction with spring boot.

``` { .xml .copy }
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-graphql-starter</artifactId>
</dependency>
```

## File with queries and mutations

In the example project, two files were created in src/main/resources/graphqls,
one for queries and another for mutations. Below are some examples.

``` { .graphql .copy }
query order($requestOrderId: Int!){
    order(id: $requestOrderId){
        id
        name
    }
}
```

``` { .graphql .copy }
mutation updateOrderMutation($updateId: Int!, $updateName: String!){
    updateOrder(id: $updateId, name: $updateName){
        id
        name
    }
}
```

This way we can organize the queries and mutations in a centralized way. It is
not necessary to pass the query/mutation when constructing the endpoint URI.

A good practice is to name your queries and later access them by defining the
**operationName** parameter.

Another point for using a file with the query is the need for encoding. When we
put the query in the construction of the endpoint, it is necessary to encode the
URI to avoid communication problems. As usual, braces {} are used for queries
and operations and $ for variables, encoding is required. For the query
parameter, this does not interfere, but when sending variable values, the field
is not recognized when it is sent with an "encoded" value (%7B={, %7D=}, %24=$).

A point to consider when using a file with the query is that when sending
information to the server, the entire content of the file is sent instead of
just the operation that was defined. Therefore, for larger queries or when
looking for performance, it is necessary to leave the file as lean as possible
so as not to transfer unnecessary information.

## Endpoint creation

In the camel route to make a graphql call we can use the following parameters:

``` { .java .copy }
.to("graphql:{{backend.order.url}}"
                        + "?queryFile=graphqls/mutationsOrder.graphql"
                        + "&operationName=deleteOrderMutation"
                        + "&variables=#variableOrderDelete")
```

Initially, we pass the information on which component will be used and its URI
(graphql:[httpUri]). In this example, we place a Camel property that is
retrieving information from application.yml.

Later we concatenate with some query parameters:

1. **queryFile**: location of the file with the query/operation.
2. **operationName**: name that identifies the query/operation. Its use is
   recommended to facilitate the identification of the transaction carried out.
3. **variables**: value of the variables defined in your query/operation. This
   field is populated with a reference to a JsonObject defined in the Spring
   context.

In addition to these 3 parameters mentioned above, there are 8 more. Their
relationship and functionality can be consulted on the component's page
(<https://camel.apache.org/components/latest/graphql-component.html>).

## How to use variables

To pass the dynamic information of the variables it is necessary to use a spring
bean to define their values for each message. If Spring was not being used, we
could use Camel's @BindToRegistry, as informed on the component's page.

In this usage, we are going to annotate a method that returns a JsonObject with
the annotation @Bean("variableOrderDelete") and a name to retrieve it. If you
want to use the name of the method, just inform it (@Bean).

``` { .java .copy }
@Bean("variableOrderDelete")
public JsonObject variableOrderDelete() {
    return new JsonObject();
}
```

To define the content of this JsonObject, we will create a processor that will
retrieve information from the message and place it in an instance of this
JsonObject.

``` { .java .copy }
public class OrderDeleteRequestProcessor implements Processor {

    @Override
    public void process(Exchange exchange) throws Exception {

        CamelContext camelContext = exchange.getContext();

        Object bean = camelContext.getRegistry().lookupByName("variableOrderDelete");

        if(bean != null) {
            JsonObject v = (JsonObject) bean;
            v.put("deleteId", exchange.getMessage().getHeader("id"));
        }

    }
}
```

The JsonObject key is the same information defined in your mutation file. In
this case **deleteId**.

``` { .java .copy }
mutation deleteOrderMutation($deleteId: Int!){
    deleteOrder(id: $deleteId)
}
```

## How to capture responses

``` { .json .copy }
{
    "data": {
        "[operationName]": [[data]]
    },
     "errors": [
        {
            "message": [data],
            "locations": [[data]],
            "extensions": {
                "classification": [data]
            }
        }
    ]
}
```

In the example project, a base class was created for its treatment:
ResponseGraphQL with this structure for deserializing the response.

For the information returned in the data field, the base class was created:
GraphQLOperation, which contains the name of the operations that can be returned
by the application.

Jackson was used to unmarshal the information.

To return the object present in the "data" or "errors" field in the message, a
processor was created for the response of the operation.

``` { .java .copy }
public class OrderDeleteResponseProcessor implements Processor{

    @Override
    public void process(Exchange exchange) throws Exception {

        ResponseGraphQL response = exchange.getMessage().getBody(ResponseGraphQL.class);

        ObjectMapper mapper = new ObjectMapper();
        String jsonResponse = "";

        if(response.getData() != null) {
            exchange.getMessage().setBody(response.getData().getDeleteOrder());
        }else if(response.getErrors() != null && response.getErrors().size() > 0) {
            jsonResponse = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(response.getErrors());
            throw new Exception(jsonResponse);
        }
    }

}
```

## References

1. [GraphQL Apache Camel
   Components](https://camel.apache.org/components/latest/graphql-component.html)
2. [GraphQL](https://graphql.org/)
3. [Server
   GraphQL](https://www.graphql-java-kickstart.com/servlet/getting-started/)
4. [Uniform Resource Identifier (URI): Generic
   Syntax](https://tools.ietf.org/html/rfc3986)
