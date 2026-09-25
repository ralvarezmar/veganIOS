# Transformation Implementation

Both the use of beans, transform and process to carry out the transformations
are supported by Camel in its most basic package, therefore, there are few
dependencies needed to use these EIPs.

## Minimal dependencies in pom.xml

``` { .xml .copy }
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-core</artifactId>
    <version>${camel-version}</version>
</dependency>
```

Camel-core is part of most modules and therefore; as soon as we add these
dependencies (eg **camel-spring-boot-starter, camel-spring-boot,
camel-starter**...) in our project, camel-core will be available.

## Transformation by DSL transform()

When we need to transform a message in a relatively straightforward way, Camel
provides the DSL **transform()** method, which together with its expression
languages allows us to perform the simplest and fastest transformations directly
in the definition of routes.

Basically, any [expression
language](https://camel.apache.org/manual/latest/expression.html) from Camel can
be used within DSL transform(), the [Simple Expression
Language](https://camel.apache.org/components/latest/languages/simple-language.html), and is
even widely used in the examples in the official documentation.

### Transformation example by transform

``` { .java .copy }
from("direct:send.new.card")
    .transform().simple(
        "${body.address.street} ${body.address.street} ${body.address.city}\n${body.address.state} ${body.address.country} ${body.address.zip}"
    )
    .to("direct:request.dispatch")
```

At times more complex transformations may be necessary, for those cases where
Simple Expression Language is not enough for a transformation directly in the
DSL, we can use other expression languages ​​supported by Camel for much more
complex transformations and uses. Generally, when it is necessary to choose a
more expressive and powerful language, we can resort to:

* [Groovy](https://camel.apache.org/components/latest/languages/groovy-language.html)
* [SpEL](https://camel.apache.org/components/latest/languages/spel-language.html)
* [MVEL](https://camel.apache.org/components/latest/mvel-component.html)
* [OGNL](https://camel.apache.org/components/latest/languages/ognl-language.html)

> [Simple Expression
> Language](https://camel.apache.org/components/latest/languages/simple-language.html) is part
> of **camel-core** and covers more than 90% of transformation needs, other
> expression languages may have specific dependencies and may need new
> dependencies in the pom.xml file.

### Transformation by Bean

To perform a per-**bean** transformation we will take advantage of Camel
integration with the ability to call any method on a **bean** as follows:
**Example of a per-bean transformation**

``` { .java .copy }
from("direct:send.new.card")
    .bean("ClientAddressTransformerBean", "toDispatchAddress")
    .to("direct:request.dispatch")
```

Continuing along the same lines as an example, assuming that the service
requesting the issuance of new credit cards needs to create the shipping order
in a logistics system..

### Inline DSL Transformations

Another way that can also be considered to apply EIP from Camel is with the use
of processors.

#### **Example of transformation by in-line processor**

``` { .java .copy }
from("direct:send.new.card")
    .process(new Processor() {
        public void process(final Exchange exchange) throws Exception {
            Customer customer = exchange.getIn().getBody(Customer.class);
            Address address = customer.getAddress();
            StringBuffer sb = new StringBuffer();

            sb.append(address.getStreet());
            sb.append(" ");
            sb.append(address.getNumber());
            sb.append(" ");
            sb.append(address.getCity());
            sb.append("\n");
            sb.append(address.getState());
            sb.append(" ");
            sb.append(address.getCountry());
            sb.append(" ");
            sb.append(address.getZip());
            sb.append(" ");
            exchange.getIn().setBody(sb.toString());
        }
    })
    .to("direct:request.dispatch");
```

!!! warning

    Note that when using a
    [Processor](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/Processor.html)
    in a Camel route, we have to make sure to write it in a safe way, as Camel
    routes can run on concurrent threads and therefore multiple threads can call
    the same
    [Processor](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/Processor.html)
    instance.

### Transformation by Processor

The use of the in-line
[processor](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/Processor.html),
that is, directly in the definition of the route, is useful to quickly generate
a block of code to carry out the most basic transformations, but with the
evolution of the code or even in a refactoring round, it is recommended to
refactor this block of code in a separate class that implements the
[Processor](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/Processor.html)
interface.

#### **Process transformation example**

``` { .java .copy }
from("direct:send.new.card")
    .process(new ClientToDispatchAddressProcessor())
    .to("direct:request.dispatch");
```

In addition to improving the readability and maintainability of the code,
another advantage of using the
[Processor](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/Processor.html)
in a separate class is the possibility of transforming our processors into an
[endpoint](https://camel.apache.org/manual/latest/endpoint.html) component of
Camel, since there is a base class called
[ProcessorEndpoint](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/impl/ProcessorEndpoint.html)
that supports the complete semantics of the Endpoint, given a instance of a
Processor.

So we just need to create a
[Component](https://camel.apache.org/manual/latest/component.html) class
deriving from
[DefaultComponent](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/impl/DefaultComponent.html)
that returns instances of
[DefaultComponent](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/impl/DefaultComponent.html).
For more details, see Camel's documentation on [creating
components](https://camel.apache.org/manual/latest/writing-components.html).

### Template Transformations

Another little-used possibility that can also be used with Camel is
**Templating** to consume a message and transform it into another format using
[Velocity](https://camel.apache.org/components/latest/velocity-component.html)
to then send it to another destination.

#### **Template transformation example**

``` { .java .copy }
from("direct:send.new.card")
    to("velocity:br/com/santander/card/DispatchAddress.vm")
    .to("direct:request.dispatch")
```

#### **DispatchAddress.vm**

``` { .java .copy }
${body.address.street} ${body.address.street} ${body.address.city}
${body.address.state} ${body.address.country} ${body.address.zip}
```

## References

### **EIP**

1. [Message Translator](https://camel.apache.org/components/latest/eips/message-translator.html)

### Groovy

1. [About Groovy](https://groovy-lang.org/)
2. [About language](https://en.wikipedia.org/wiki/Apache_Groovy)

### SpEL - Spring Expression Language

1. [SpEL](https://docs.spring.io/spring/docs/4.3.10.RELEASE/spring-framework-reference/html/expressions.html)
