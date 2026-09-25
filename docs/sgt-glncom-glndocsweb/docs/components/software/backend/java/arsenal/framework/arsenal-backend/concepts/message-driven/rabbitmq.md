# RabbitMQ

__RabbitMQ__ is an open-source message broker software. It accepts messages from
producers and delivers them to consumers. It acts like a middleman which can be
used to reduce loads and delivery times taken by web application servers.

## Message Brokers

__Message brokers__ take care of the connections between applications. Based on
the requirement, a bi-directional connection will be created between each
application system and message broker. __Messages__ are then transported via
this connection. __Message brokers__ act as a hub to route appropriate messages
to appropriate destinations. In a nutshell, a __Message Broker__ routes
appropriate messages to their appropriate destinations, similar to the way a
Telephone Switching Office works.

## RabbitMQ Terminologies and Concepts

__Producer__: A producer is a user application that sends messages to the
consumers.

__Consumer__: A consumer is a user application that receives messages.

__Message__: It is a data transporter between a sender application and a
receiver application. What kind of data does the message consist of? It could be
a signal to inform an application to start processing a task, or tell an
application about the completion of a task by another application. The message
could hold crucial information required by the application for its own
processing.

__Exchange__: An exchange is a very simple thing. On one side it receives
messages from producers and the other side pushes them to queues. This is a
place that messages come first and its main purpose is to decide which consumer
application, the message should go!

__Queue__: A queue is a buffer that stores messages basically, the exchange
routes the message to queues, then the consumer clients receive messages from
the queue. We have queues as many as the consumer’s applications The producers
send the message to the exchange first, the exchange decides which queues, the
message should go.

## AMQP Protocol

It is a protocol primarily used for message oriented middleware. Some of the
impressive features it offers are message orientation, queuing, reliability,
security and routing.

__AMQP__ mandates the behaviour of message publisher and message consumer for
seamless transportation of messages between different applications built by
different vendors in different programming languages.

## Message flow in RabbitMQ

__Messages__ published by a publisher are first received by the __Exchange__ in
__RabbitMQ__, then __Exchanges__ will distribute message copies to __Queues__.
To send appropriate messages to the appropriate queues, rules called
__Bindings__ are used.

Since __Queues__ are consumer facing, it’s crucial that the __Exchanges__ route
messages to the appropriate __Queues__, and Bindings play an important role in
this.

Once the messages reach __Queues__, messages can be delivered to the appropriate
consumer or consumers can fetch the messages from the __Queues__.

When publishing a message, a publisher can pass attributes along with the
message. The attributes can be used by __RabbitMQ__ and the consumer
applications.

What happens when a message fails to deliver to a consumer? This can occur due
to a network or application failure. If either of these failures was to occur,
our system could potentially lose the message forever.

To address this issue, __AMQP__ has a delivery acknowledgement mechanism in
place. So a message will not be completely removed from a __Queue__ unless we
send a positive acknowledgment from the consumer. In the case of a negative
acknowledgment, the message can be re-sent to the consumer or it can be dropped
depending on the configuration settings by the publisher when sending the
message.

In __AMQP__, the applications has more control over the message it sends, the
application can define the exchange type that has to receive the message, and
the queue where the message has to be saved. It can also define the routing
scheme which binds the __Exchange__ with __Queues__ and it can control the
message fetching and distribution logic on the __Queues__.

## Types of exchanges in RabbitMQ

__Fanout__: This exchange basically sends a copy of messages to all the queues
it knows.

__Direct__: A direct exchange delivers messages to queues based on a message
routing key. The routing key is a message attribute added to the message header
by the producer. Think of the routing key as an “address” that the exchange is
using to decide how to route the message.

__Topic__: Topic exchanges route messages to one or many queues based on
matching between a message routing key and the pattern that was used to bind a
queue to an exchange.

__Headers__: A header exchange is an exchange that route messages to queues
based on message header values instead of routing key. If a match is found, it
routes the message to the queue whose binding value is matched and if a match is
not found, it ignored the message.
