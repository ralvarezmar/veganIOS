# Error Handling

In Camel, error handling is done with onException methods declared in routes for
each exception to be handled.

We'll start by looking at how Camel inspects the exception hierarchy to
determine how to handle the error. This will give you a better understanding of
how to use exception handling.

Imagine you have this exception with underlying wrapped exceptions being thrown:

**org.apache.camel.RuntimeCamelException \- com.mycompany.OrderFailedException \--
java.net.ConnectException**

The real cause is a ConnectException, but it's wrapped in an
OrderFailedException and then again in a RuntimeCamelException.

Camel will traverse the hierarchy from the bottom up to the root, looking for an
onException that matches the exception. In this case, Camel will start with
java.net.ConnectException, go to com.mycompany.OrderFailedException, and finally
RuntimeCamelException. For each of these three exceptions, Camel will compare
the exception against the defined onExceptions to select the best match. If no
suitable policy can be found, Camel will use standard error handling, throwing
the exception to the consumer and logging.

Below is a code example, which handles some exceptions, generating an http
response with the appropriate error code.

```{.java .copy}
// catch ConnectException
onException(ConnectException.class)
    .handled(true)
    .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(500))
    .setBody(simple("ConnectException"));

// catch IOException
onException(IOException.class)
    .handled(true)
    .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(500))
    .setBody(simple("IOException"));

// catch Exception
onException(Exception.class)
    .handled(true)
    .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(500))
    .setBody(simple("Exception"));

from("direct:allCustomer")
    .process(exchange -> {
        System.out.println("processo 1");
    }).process(exchange -> {
        System.out.println("processo 2");
    }).process(exchange -> {
        System.out.println("processo 3");
        // force a throw exception, only for test
        throw new Exception("Thow Error");
    }).to("bean:customerBean?method=getAllCustomers()");
```
