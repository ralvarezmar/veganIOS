# Aggregation Implementation

Minimal dependencies in pom.xml

``` { .xml .copy }
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-core</artifactId>
    <version>${camel-version}</version>
</dependency>
```

Camel-core is part of most modules and therefore; as soon as we add these
dependencies (eg camel-spring-boot-starter, camel-spring-boot, camel-starter...)
in our project, camel-core will be available automatically.

## Defining the aggregation strategy

The
[AggregationStrategy](https://camel.apache.org/components/latest/eips/aggregate-eip.html#_about_aggregationstrategy)
is used to aggregate the old message (may use an ID for correlation) and the new
messages into a single new message. Possible implementations include performing
some sort of blending or processing, such as adding line items to an invoice, or
just using the latest message and removing older messages, such as tracking the
state of a resource for example.

!!! warning

    Note that the aggregation strategy is a mandatory option and must be
    provided to the aggregator.

Each integration scenario will contain specific aggregation rules, in the
example of
[AggregationStrategy](https://camel.apache.org/components/latest/eips/aggregate-eip.html#_about_aggregationstrategy)
implementations we synchronously aggregate all live messages of a multicast.

``` { .java .copy }
...
public class FinancialPositionAggregatorStrategy implements AggregationStrategy {
    @Override
    public Exchange aggregate(Exchange oldExchange, Exchange newExchange) {
        List<FinancialPosition> financialPositions;
        if (oldExchange == null) {
            financialPositions = new ArrayList<>();
        } else {
            financialPositions = (List<FinancialPosition>) oldExchange.getIn().getBody();
        }
        financialPositions.add(newExchange.getIn().getBody(FinancialPosition.class));
        newExchange.getIn().setBody(financialPositions);
        return newExchange;
    }
...
```

On the first call of the aggregate method, the oldExchange parameter is null.
The reason is that we haven't added anything yet. So just the newExchange that
has a value. Normally, we can just return the newExchange in this situation. But
we still have the power to decide what to do; for example, we can do some toggle
on swap or remove some headers. The return of the aggregate method should be a
combination of the two messages, always favoring the return of the oldest
message whenever possible.

There are some ways to signal that the aggregation should be finished, otherwise
Camel would keep aggregating all the messages forever. For that, we must inform
that the messages that will be aggregated are completed, so that Camel can send
the aggregated message out of the aggregator. Camel allows us to indicate
completion in several ways, as follows:

* ***completionTimeout***: Defines a timeout if no message is received;
* ***completionInterval***: At every X time interval the aggregation is
  completed;
* ***completionSize***: Every time X messages are received, the aggregation is
  finalized;
* ***completionPredicate***: Executes a test to verify if the aggregation is
  finished. The
  [AggregationStrategy](https://camel.apache.org/components/latest/eips/aggregate-eip.html#_about_aggregationstrategy)
  itself can implement the tests to indicate the completion of the aggregation;
* ***completionFromBatchConsumer***: Used to complete an aggregation when all
  messages from a [Batch
  Consumer](https://camel.apache.org/manual/latest/batch-consumer.html);
* ***forceCompletionOnStop***: Forces the completion of aggregations when the
  Camel context is stopped, thus ensuring the sending of messages stopped in the
  aggregation; or
* Using an ***AggregateController***: Allows us to use an external source to
  finalize the aggregations.

In most cases we can use messages received at the aggregator to determine
whether the cluster should be pre-completed and then start a new cluster from
scratch. To determine this,
[AggregationStrategy](https://camel.apache.org/components/latest/eips/aggregate-eip.html#_about_aggregationstrategy)
can implement
[PreCompletionAwareAggregationStrategy](https://static.javadoc.io/org.apache.camel/camel-core/2.24.2/org/apache/camel/processor/aggregate/PreCompletionAwareAggregationStrategy.html)
which has a preComplete method:

``` { .java .copy }
...
@Override
public boolean preComplete(Exchange oldExchange, Exchange newExchange) {
    if (oldExchange != null) {
        List<FinancialPosition> financialPositions = (List<FinancialPosition>) oldExchange.getIn().getBody();
        return  financialPositions.size() == 4;
    }
    return false;
}
...
```
