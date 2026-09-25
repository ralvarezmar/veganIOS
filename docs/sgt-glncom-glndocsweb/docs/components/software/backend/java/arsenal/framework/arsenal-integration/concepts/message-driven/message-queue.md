# Message Queue

## Asynchronous Communication

Another name for asynchronous communication is non-blocking communication, the
application sending a request does not have to wait for a response to continue
operating. The connection between sender and receiver will be closed once the
request is sent. It also means that multiple processes can run in parallel.

This type of communication is especially effective when there are large volumes
of data that need to be processed and is best suited when no immediate response
is expected or required.

Asynchronous message passing patterns are considered more reliable than
synchronous as no application would have a timeout due to waiting for the
response, which logically leads to higher service availability. Also, additional
functionality can be implemented in the messaging system and not in the
communication. But actually it completely depends on the use case.

Below are the standards in detail:

### Asynchronous Receiver

This pattern implements message consumption through queues.

Example: An application responsible for quotes has the value of a currency
updated, it sends an event through a queue, the consumer waits for events in
that queue and processes them at each arrival of messages.
