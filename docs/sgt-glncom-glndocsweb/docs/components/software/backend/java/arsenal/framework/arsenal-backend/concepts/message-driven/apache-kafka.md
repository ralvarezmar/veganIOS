# Apache Kafka

Apache Kafka is a open-source stream-processing software for collecting,
processing, storing, and analyzing data at scale. It is a implementation of
*Publish-Subscribe Channel* that is one of Messaging Patterns describe at
[Enterprise Integration
Patterns](https://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html).

It was created by LinkedIn and delivery to community in 2011. It was written
using Java and Scala.

## Where/How is used?

* In asynchronous communication between a lot of types of system that demands a
  high throughput.
* Publish (write) and subscribe to (read) streams of events, including
  continuous import/export of your data from other systems.
* Store streams of events durably and reliably for as long as you want.
* Process streams of events as they occur or retrospectively.

## Why?

With Kafka you can decoupling between the message producer and the message
consumer. The producer doesn't have to know about who will consume that message
and how many. Instead of sending a direct message to each consumer using his
expected format it only sent to Kafka. The consumer also doesn't know about the
producer that produced the data that's reading. There is a segregation of
responsibility in this communication.

Some highlight features:

* High throughput: a lot of messages in a very short time, some units of
  milliseconds.
* Scalable: the numbers are thousands of clusters, trillions of messages,
  petabytes of data, hundred thousands of partitions. Scaling up or down the
  storage and processing.
* Fault tolerance: the data is distributed between brokers
* High availability: multi region clusters connected
* Active open source community
* Well adopted by companies

## Key concepts and pieces

* Producer: application that you put data into kafka
* Consumer: application that you read data
* Topics: an ordered collections of related messages or related events that is
  stored in a durable way
* Partitions: are segments of topics that is spread in different brokers
* Broker: is the server that contains a node of Apache Kafka. It receives and
  delivery messages.
* Kafka cluster: a group of brokers with your own local storage, topics and
  partitions
* Message: is the data structure that lives in a topic. Essentially contains a
  key/value. And are inserted in the end of a topic and receive a unique offset
  in partition context.
* Offset: An exclusive ordered key from messages in a partition
* Consumer group: a group of consumers consuming the same topic.
* Kafka connector: available applications that collects data from some product
  to put into kafka
* Apache Zookeeper: cluster coordinator. Part of apache kafka architecture. It
  manage consensus on few pieces of distributed state. Like new broker lider in
  case of failure. Also responsible for access control list.
* Apache Kafka Raft (KRaft) is the consensus protocol that was introduced to
  remove Apache Kafka’s dependency on ZooKeeper for metadata management. In
  April 2023 is not a recommendation from production environments.

## How it works?

When a data is produced it is not sent to a particular destination it is send to
a structure inside the Kafta cluster, called Topic.

The cardinality from a Topic to Producers and Consumers are n to n:

* n producers writing a topic.
* 1 producer writing multiple topics.
* n consumers can consume a topic
* 1 consumer can consume n topics.

A Topic can be segmented into partitions and then be able to *allocate those
partitions to different brokers in the cluster*. This is the key to how Kafka
*scales*.

A partition is essentially a log file. So every partition has strict ordering.
When a message is produce to a partition it is put on the end of the partition.
Any of previous message can not be modified or reorder. They are immutable
events. The message ordering is guarantee on a partition not in a topic.

Each partition is broken in segments that is write on disk and has its own
unique offset space.

When a message is consumed it is not destroyed, it's just read.

## Message structure

Every event has a key and a value, a creation time or ingestion time and
optional headers (its a metadata, a property of the data, not additional
payload).

## Brokers

Has the responsibility to manage partitions, store pubs/subs for the retention
time defined. Each broker has your exclusive storage. They are network together
and act together forming a Kafka cluster. They can have many partitions
configured.

## Replication

The common replication factor is 3. So, we usually have 3 brokers. One of them
is a leader and the orders are the followers. The producer is connect to the
broker that has the lead partition there. It's the job of the brokers with
follower partitions to reach out those leaders and scrape the new messages that
they have got and keep up to date with them as quickly as possible.

## Data distribution

The messages produces to a topic are written in a balance way using the round
robin strategy through the existing partitions. Unless is defined a key to the
message. With this key is generated a hash and mod by number of partitions and
the result is the number of a partition to write this message. So the messages
with the same key is maintained ordered in the same partition. As long as the
number of the partitions remains the same.

## Message consumes

Consumers asks to Kafka clusters that is subscribed to a certain topic what is
last offset that read. There is any message after that offset? This questions is
continuous repeatedly in a very short period of time. The consumer offset into
each partition is storing in memory and also stored in special topic inside the
Kafka cluster called consumer offset.

When a message of a topic is consumed by a consumer group the apache kafka acts
like a traditional point to point messaging system when only one consumer
between the group reads the message. All the partitions topic are divided among
the consumers of group. Each member reads only the data from the partitions that
is assigned to them. With this we achieve the parallel processing of the topic
data.
