# Distributed Cache

Cache is one type of memory. There are several types of cache memory, but in
this article, we will discuss only the caches at the level of applications.

The main goal of using cache is to be able to store and retrieve information
much faster and more efficiently than accessing database, reading file,
requesting from another microservice or accessing any other source external to
the application.

This page will discuss about the distributed cache capability and its use cases,
see the Local Cache page to learn more about this capability and the scenarios
where it can be applied.

## Why use cache?

The main usage of cache is to improve performance, reduce resource consumption
and, consequently, reduce costs. Complex operations (processing or IO
operations) and very frequent operations tend to make system performance worse
by using a lot of computing resources. Resources are finite and have a cost, so
the less access to an external system, such as database, or repetitive
calculations (with the same result) are made  or avoided, the better.

The most common usage of cache is to reduce database overload, as they generally
act as a single point of access that must serve multiple services. Use of cache
in this case is very common, especially in the banking and financial sector,
which requires scalable, high-performance applications.

## When should I use Distributed Cache?

Distributed cache is a scalable storage system external to the application that
allows high-performance data access. Unlike the local cache, the information
stored in the distributed cache **is** shared among all instances of same
application.

Data stored in the distributed cache is usually available for a predetermined
interval of time, we call this TTL (time to live). After the TTL expires, the
data is automatically removed from the cache and must be persisted again in the
next operation.

For this reason, the information persisted in the distributed cache:

* must be shareable (not exclusive), that is, they are used by other instances
  of the same application;
* can be volatile, that is, they become invalid after a certain period of time;
* can be mutable, that is, they can be updated.

### Usage Examples

Here are some examples of when distributed cache can be used:

**Services with high volume of queries:**

* data typically used to fill in combo boxes on screens (eg countries, banks,
  currencies);
* frequently accessed business data (eg registration data, currency conversion
  rates);
* business data that makes easier to check conditions and business rules (eg
  list of customers and their account numbers).

**Authorization to execute operations:**

* session tokens: tokens that hold basic user or session information can be
  cached for quick verification and access;
* access permissions: a permissions list per user can be cached for quick
  checking without having to access a database.

!!! note

    Note how the time to live (TTL) of cached information can vary by use case. Data such as a list of states in a country can be cached for many hours or days, as the probability of changing this data is almost zero. On the other hand, business data
    like the conversion rate between two currencies can probably only be cached for a few minutes.

    Always consult your PO and the business area on whether to cache business information and what TTL should be used.
