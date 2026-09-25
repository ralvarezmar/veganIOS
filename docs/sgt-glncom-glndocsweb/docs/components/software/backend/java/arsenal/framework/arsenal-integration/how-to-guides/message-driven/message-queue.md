# Implementing Message Queue

In the application configuration file, it will be necessary to include the
information of the IBM MQ Queue Manager that will be used

``` { .yaml .copy }
project:
  mq:
    host: localhost
    port: 1414
    queue-manager: QM_TESTE
    channel: CAMEL.SVRCONN
```

We will use Camel's **JMS (Java Message Service)** component for integration
with IBM MQ, for that, we must create 2 configuration Beans.

The first will create an instance of **JmsConnectionFactory**, this will be
responsible for managing connections with IBM MQ. The second will create a
custom **JmsComponent** instance that will use the ConnectionFactory created
earlier and will be used in Camel routes to access IBM MQ.

``` { .java .copy }
package br.com.santander.mq.config;

import javax.jms.ConnectionFactory;
import javax.jms.JMSException;

import org.apache.camel.component.jms.JmsComponent;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.ibm.msg.client.jms.JmsConnectionFactory;
import com.ibm.msg.client.jms.JmsFactoryFactory;
import com.ibm.msg.client.wmq.WMQConstants;

/** Configuration class for creating mq connection and jms component */
@Configuration
public class JmsConfig {

    /** MQ server host. */
    @Value("${project.mq.host}")
    private String host;

    /** MQ server port. */
    @Value("${project.mq.port}")
    private Integer port;

    /** Queue Manager name. */
    @Value("${project.mq.queue-manager}")
    private String queueManager;

    /** Queue Manager channel. */
    @Value("${project.mq.channel}")
    private String channel;

    /**
     * Creates Connection Factory to manage connections to IBM MQ.
     *
     * @return Factory JmsConnectionFactory.
     */
    @Bean
    public JmsConnectionFactory createConnectionFactory() throws JMSException {

        JmsFactoryFactory ff = JmsFactoryFactory.getInstance(WMQConstants.WMQ_PROVIDER);

        JmsConnectionFactory cf = ff.createConnectionFactory();

        // Configure the connection properties
        cf.setStringProperty(WMQConstants.WMQ_HOST_NAME, host);
        cf.setStringProperty(WMQConstants.WMQ_QUEUE_MANAGER, queueManager);
        cf.setStringProperty(WMQConstants.WMQ_CHANNEL, channel);
        cf.setIntProperty(WMQConstants.WMQ_PORT, port);
        cf.setIntProperty(WMQConstants.WMQ_CONNECTION_MODE, WMQConstants.WMQ_CM_CLIENT);
        cf.setIntProperty(WMQConstants.WMQ_CLIENT_RECONNECT_OPTIONS, WMQConstants.WMQ_CLIENT_RECONNECT_Q_MGR);

        return cf;
    }

    /**
     * Creates Jms Camel Componente to connect to IBM MQ.
     *
     * @return Component JmsComponent.
     */
    @Bean(name="wmq")
    public JmsComponent jmsComponent(final ConnectionFactory connectionFactory) {
        // Create Jms Component using a Jms Connection Factory as param.
        JmsComponent jmsComponent = JmsComponent.jmsComponent(connectionFactory);
        return jmsComponent;
    }
}
```

In the example below a Camel route has been created to connect to MQ and perform
processing for each message that arrives on the queue.

``` { .java .copy }
package br.com.santander.mq.route;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

@Component
public class CamelMQRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {

        // Endpoint responsible to listening to IBM MQ queue
        from("wmq:queue:QL.TESTE.CAMEL")
            .process(exchange -> {
                // do something
            })
            .stop();
    }
}
```

The connection to mq can be detailed as follows:

**wmq**: the Jms component alias created earlier.

**queue**:QL.TESTE.CAMEL: indicates that the queue QL.TESTE.CAMEL will be used

## Fire and Forget

This pattern of message exchange is also called one-way, because an application
sends a request and continues to operate without waiting for a response from the
target application or system, although it usually expects some acknowledgment of
this. It is a typical asynchronous communication pattern.

Example: A very classic example would be regularly synchronizing data between a
cloud-based CRM application and an on-premises ERP system, so that the
data in both applications is up to date. Imagining a sales employee adding new
account data or changing existing data in the CRM application. The CRM would
identify the changes and put them, for example, in a queue in an integration
middleware, from where it will eventually be picked up or sent to the ERP
system. It doesn't really matter to the user or your business processes when the
update takes place - immediately or within an hour - as long as it happens
eventually.

### Implementing the pattern

In the application configuration file, it will be necessary to include the
information of the IBM MQ Queue Manager that will be used

``` { .yaml .copy }
project:
  mq:
    host: localhost
    port: 1414
    queue-manager: QM_TESTE
    channel: CAMEL.SVRCONN
```

We will use Camel's **JMS (Java Message Service)** component for integration
with IBM MQ, for that, we must create 2 configuration Beans.

The first will create an instance of **JmsConnectionFactory**, this will be
responsible for managing connections with IBM MQ. The second will create a
custom **JmsComponent** instance that will use the ConnectionFactory created
earlier and will be used in Camel routes to access IBM MQ.

``` { .java .copy }
package br.com.santander.mq.config;

import javax.jms.ConnectionFactory;
import javax.jms.JMSException;

import org.apache.camel.component.jms.JmsComponent;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.ibm.msg.client.jms.JmsConnectionFactory;
import com.ibm.msg.client.jms.JmsFactoryFactory;
import com.ibm.msg.client.wmq.WMQConstants;

/** Configuration class for creating mq connection and jms component */
@Configuration
public class JmsConfig {

    /** MQ server host. */
    @Value("${project.mq.host}")
    private String host;

    /** MQ server port. */
    @Value("${project.mq.port}")
    private Integer port;

    /** Queue Manager name. */
    @Value("${project.mq.queue-manager}")
    private String queueManager;

    /** Queue Manager channel. */
    @Value("${project.mq.channel}")
    private String channel;

    /**
     * Creates Connection Factory to manage connections to IBM MQ.
     *
     * @return Factory JmsConnectionFactory.
     */
    @Bean
    public JmsConnectionFactory createConnectionFactory() throws JMSException {

        JmsFactoryFactory ff = JmsFactoryFactory.getInstance(WMQConstants.WMQ_PROVIDER);

        JmsConnectionFactory cf = ff.createConnectionFactory();

        // Configure the connection properties
        cf.setStringProperty(WMQConstants.WMQ_HOST_NAME, host);
        cf.setStringProperty(WMQConstants.WMQ_QUEUE_MANAGER, queueManager);
        cf.setStringProperty(WMQConstants.WMQ_CHANNEL, channel);
        cf.setIntProperty(WMQConstants.WMQ_PORT, port);
        cf.setIntProperty(WMQConstants.WMQ_CONNECTION_MODE, WMQConstants.WMQ_CM_CLIENT);
        cf.setIntProperty(WMQConstants.WMQ_CLIENT_RECONNECT_OPTIONS, WMQConstants.WMQ_CLIENT_RECONNECT_Q_MGR);

        return cf;
    }

    /**
     * Creates Jms Camel Componente to connect to IBM MQ.
     *
     * @return Component JmsComponent.
     */
    @Bean(name="wmq")
    public JmsComponent jmsComponent(final ConnectionFactory connectionFactory) {
        // Create Jms Component using a Jms Connection Factory as param.
        JmsComponent jmsComponent = JmsComponent.jmsComponent(connectionFactory);
        return jmsComponent;
    }
}
```

In the example below, a Camel route was created exposing a REST service, which
receives the message and forwards it to the destination queue, returning
immediately to the consumer.

``` { .java .copy }
package br.com.santander.mq.route;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.rest.RestBindingMode;
import org.springframework.stereotype.Component;

@Component
public class CamelMQRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {

        restConfiguration()
                .bindingMode(RestBindingMode.auto);

        // Expose a http rest endpoint using json
        rest("/mq")
            .consumes("application/json").produces("application/json")
            .post("/cont")
                .to("direct:mq");

        // Endpoint responsible to connect to IBM MQ
        from("direct:mq")
            // put a message in a mq queue
            .to("wmq:queue:QL.TESTE.CAMEL?disableReplyTo=true");
    }
}
```

The connection to mq can be detailed as follows:

**wmq**: the Jms component alias created earlier.

**queue**:QL.TESTE.CAMEL: indicates that the queue QL.TESTE.CAMEL will be used

**disableReplyTo=true**: tells Camel that it shouldn't wait for a return message

## Request - Reply

In this pattern, the requester sends a message to a provider system, which
receives and processes the request, returning a message in response. This allows
two applications to have a two-way conversation with each other over a channel.

Example: The requester sends a request and waits for a response message. The
service provider receives the request message and responds with a response or
failure message. After sending the request message, the requester waits until
the service provider responds with a message or timeout. Both the request and
response messages are independent.

The **Request-Reply** pattern implemented through MQ has a high computational
cost since it locks up resources while waiting for a response. It should only be
used when this is the only way to integrate with the provider.

### Implementing the pattern in Camel

In the application configuration file, it will be necessary to include the
information of the IBM MQ Queue Manager that will be used

``` { .yaml .copy }
project:
  mq:
    host: localhost
    port: 1414
    queue-manager: QM_TESTE
    channel: CAMEL.SVRCONN
```

We will use Camel's **JMS (Java Message Service)** component for integration
with IBM MQ, for that, we must create 2 configuration Beans.

The first will create an instance of **JmsConnectionFactory**, this will be
responsible for managing connections with IBM MQ. The second will create a
custom **JmsComponent** instance that will use the ConnectionFactory created
earlier and will be used in Camel routes to access IBM MQ.

``` { .java .copy }
package br.com.santander.mq.config;

import javax.jms.ConnectionFactory;
import javax.jms.JMSException;

import org.apache.camel.component.jms.JmsComponent;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.ibm.msg.client.jms.JmsConnectionFactory;
import com.ibm.msg.client.jms.JmsFactoryFactory;
import com.ibm.msg.client.wmq.WMQConstants;

/** Configuration class for creating mq connection and jms component */
@Configuration
public class JmsConfig {

    /** MQ server host. */
    @Value("${project.mq.host}")
    private String host;

    /** MQ server port. */
    @Value("${project.mq.port}")
    private Integer port;

    /** Queue Manager name. */
    @Value("${project.mq.queue-manager}")
    private String queueManager;

    /** Queue Manager channel. */
    @Value("${project.mq.channel}")
    private String channel;

    /**
     * Creates Connection Factory to manage connections to IBM MQ.
     *
     * @return Factory JmsConnectionFactory.
     */
    @Bean
    public JmsConnectionFactory createConnectionFactory() throws JMSException {

        JmsFactoryFactory ff = JmsFactoryFactory.getInstance(WMQConstants.WMQ_PROVIDER);

        JmsConnectionFactory cf = ff.createConnectionFactory();

        // Configure the connection properties
        cf.setStringProperty(WMQConstants.WMQ_HOST_NAME, host);
        cf.setStringProperty(WMQConstants.WMQ_QUEUE_MANAGER, queueManager);
        cf.setStringProperty(WMQConstants.WMQ_CHANNEL, channel);
        cf.setIntProperty(WMQConstants.WMQ_PORT, port);
        cf.setIntProperty(WMQConstants.WMQ_CONNECTION_MODE, WMQConstants.WMQ_CM_CLIENT);
        cf.setIntProperty(WMQConstants.WMQ_CLIENT_RECONNECT_OPTIONS, WMQConstants.WMQ_CLIENT_RECONNECT_Q_MGR);

        return cf;
    }

    /**
     * Creates Jms Camel Componente to connect to IBM MQ.
     *
     * @return Component JmsComponent.
     */
    @Bean(name="wmq")
    public JmsComponent jmsComponent(final ConnectionFactory connectionFactory) {
        // Create Jms Component using a Jms Connection Factory as param.
        JmsComponent jmsComponent = JmsComponent.jmsComponent(connectionFactory);
        return jmsComponent;
    }
}
```

In the example below, a Camel route was created exposing a REST service, which
receives the message and forwards it to the destination queue, waiting for the
provider's response.

``` { .java .copy }
package br.com.santander.mq.route;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.rest.RestBindingMode;
import org.springframework.stereotype.Component;

@Component
public class CamelMQRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {

        restConfiguration()
                .bindingMode(RestBindingMode.auto);

        // Expose a http rest endpoint using json
        rest("/mq")
            .consumes("application/json").produces("application/json")
            .post("/cont")
                .to("direct:mq");

        // Endpoint responsible to connect to IBM MQ and wait for a reply
        from("direct:mq")
            .to("wmq:queue:QL.TESTE.CAMEL?replyTo=QL.TESTE.CAMEL.RSP" +
                                        "&useMessageIDAsCorrelationID=true" +
                                        "&requestTimeout=5s");
    }
}
```

The connection to mq can be detailed as follows:

**wmq**: the Jms component alias created earlier.

**queue:QL.TESTE.CAMEL**: indicates that the queue QL.TESTE.CAMEL will be used

**replyTo=QL.TESTE.CAMEL.RSP**: queue that will be used for reply

**useMessageIDAsCorrelationID=true**: tells Camel to look for a message in the
response queue with Correlation ID equal to the Message ID it sent

**requestTimeout=5s**: sets the timeout time to 5s

**Important**: The message returned by the provider must have the lifetime
parameter configured, so if the provider returns the message after the timeout
occurs, the message will not remain in the queue forever.

### Concurrent consumption for N instances of MQ

How to define a bean for concurrent consumption of queues for multi-instance MQ
scenarios in PaaS:

``` { .java .copy }
@Bean(name="wmq")
public JmsComponent jmsComponent(final ConnectionFactory connectionFactory) {
    JmsComponent jmsComponent = JmsComponent.jmsComponent(connectionFactory);
    jmsComponent.setConcurrentConsumers(CONCURRENT_CONSUMERS);
    jmsComponent.setMaxConcurrentConsumers(MAX_CONCURRENT_CONSUMERS);
    jmsComponent.setMaxMessagesPerTask(MAX_MESSAGES);

    return jmsComponent;
}
```
