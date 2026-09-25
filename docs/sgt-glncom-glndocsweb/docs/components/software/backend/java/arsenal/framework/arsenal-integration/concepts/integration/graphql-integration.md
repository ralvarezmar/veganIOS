# Graphql Integration

## Need

How do I communicate with a GraphQL backend using Apache Camel

## Solution

To meet this need, Camel provides the
[graphQL](https://camel.apache.org/components/latest/graphql-component.html)
component.

Some initial considerations:

Camel's graphql component only supports **producer** mode, that is, it is a
client that makes graphql calls. Unable to make a Camel route consume a graphql.
That is, graphql server mode is not supported.

## Implementation

[How to implements EIP GraphQL](../../how-to-guides/integration/graphql-integration.md)
