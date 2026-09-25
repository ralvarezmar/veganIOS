# Enrichment

## Need

When sending messages from one service to another, it is common for the
destination service to require more data than the source service can provide.
For example, the Address messages received may contain only the zip code and the
house number, as it may seem simpler than storing only these two data, in
addition to seeming redundant to persist with the state, country, etc. code.
Another service will likely need to specify the state and zip code. However,
another service might not use state, country, or even zip codes, but instead use
the free-form address to support international addresses by being just one big
String. Likewise, a service might give us a customer ID, but the receiving
service actually requires the customer's name and address. An order message sent
by the order management service can only contain an order number, but we need to
find the customer ID associated with that order so we can pass it on to the
customer management service. Scenarios are plentiful.

How do we communicate with another service if the message originator doesn't
have all the necessary data available?

## Solution

To address this problem Camel provides a specialized transformer, implementing
the [EIP Content
Enricher](https://www.enterpriseintegrationpatterns.com/patterns/messaging/), to
access an external data source in order to enrich a message with necessary
information.

![enrichment](../../assets/images/enrichment1.png)

[Content Enricher](https://camel.apache.org/components/latest/eips/enrich-eip.html) uses
information within the received message (eg Ids or any other identifier) to
retrieve data from an external source. After [Content
Enricher](https://camel.apache.org/components/latest/eips/enrich-eip.html) retrieves the
required data from the resource, it appends the data to the message. The
original information from the received message must be transferred to the new
message for it to be considered in fact a [Content
Enricher](https://camel.apache.org/components/latest/eips/enrich-eip.html), in cases
where the original message is no longer needed, depending on the specific needs
of the service you are going to receive, we are applying the Message Translator.

## Implementation

[How to implements EIP Enrichment](../../how-to-guides/integration/enrichment.md)
