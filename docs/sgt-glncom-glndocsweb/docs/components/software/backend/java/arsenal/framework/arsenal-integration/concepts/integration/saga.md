# Saga

## Definition of "consistency"

There is no single definition of the term "consistency", but a widely accepted
definition is "keep the system as a whole in a valid state" ("valid" means:
"respecting all business invariants").

Let's try to make it more concrete with an example. Suppose you have designed an
e-commerce system that allows you to place a purchase order, using two external
services, one for registering the order and the other for debiting the purchase
amount.

From a business perspective, your main invariant here is simply stated as:

For any purchase, a purchase order and a debit must be created, or neither of
them.

This means, in simple words, that when a user buys a cellphone, the system must
post a purchase order for the cellphone and debit the financial system for the
purchase price. But it should never place the purchase order if the debit was
not possible due to some kind of restriction or insufficient funds. We must
either approve the purchase or inform the user that the item cannot be bought.

But the problem is that we have two different systems for registering the order
and making the debit. How do we coordinate them? Saga pattern was created to
solve this kind of problem.

## Saga pattern in Camel

Explanation from [Camel Documentation](https://camel.apache.org/components/latest/eips/saga-eip.html):

The Saga EIP provides a way to define a series of related actions in a Camel
route that should be either completed successfully (all of them) or
not-executed/compensated. Sagas implementations are able to coordinate
distributed services communicating using any transport towards a globally
consistent outcome.

Although their main purpose is similar, Sagas are different from classical ACID
distributed (XA) transactions because the status of the different participating
services is guaranteed to be consistent only at the end of the Saga and not in
any intermediate step (lack of isolation).

Conversely, Sagas are suitable for many use cases where usage of distributed
transactions is discouraged. For example, services participating in a Saga are
allowed to use any kind of datastore: classical databases or even NoSQL
non-transactional databases. Sagas are also suitable for being used in stateless
cloud services as they do not require a transaction log to be stored alongside
the service.

Sagas don’t use locks on data, instead they define the concept of "Compensating
Action" that is an action that should be executed when the standard flow
encounters an error, with the purpose of restoring the status that was present
before the flow execution. Compensating actions can be declared in Camel routes
using the Java or XML DSL and will be invoked by Camel only when needed (if the
saga is cancelled due to an error).
