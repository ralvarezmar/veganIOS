# Local Cache

Cache is one type of memory. There are several types of cache memory, but in
this article, we will discuss only the caches at the level of applications.

The main goal of using cache is to be able to store and retrieve information
much faster and more efficiently than accessing database, reading file,
requesting from another microservice or accessing any other source external to
the application.

This page will discuss about the local cache capability and its use cases, see
the Distributed Cache page to learn more about this capability and the scenarios
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

## When should I use Local Cache?

The local cache is used to persist data that can be accessed exclusively by the
instance of the specified application.

The local cache is typically populated during application startup and the data
is available the entire time the application is running. Remember that on the
OpenShift platform, there are several instances (or copies) of our application
running in parallel, and in this case each of them has its own local cache. Data
stored in the local cache is not shared between instances!

For this reason, the information persisted in the local cache must:

* be exclusive (non-shareable), that is, they cannot be used by other instances
  of same application
* be static and doesn't need synchronization between instances;
* have extremely low or zero update frequency, that is, immutable or almost
  immutable information.

### Usage Examples

Here are some examples of when local cache can be used:

**Data used internally by the application:**

* internal codes for country, state and city;
* internal codes for industry sectors, professions, positions etc;
* codes of agencies, banks and other institutions.

**Historical data used for calculations:**

* historical series of currency quotations;
* historical series of economic indicators (GDP, inflation etc);
* historical series of taxes and funds.

!!! warning

    Never use local cache to store data that is returned by APIs! Use Distributed Cache instead!
