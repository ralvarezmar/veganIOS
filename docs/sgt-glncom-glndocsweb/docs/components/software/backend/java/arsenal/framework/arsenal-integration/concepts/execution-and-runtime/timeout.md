# Timeout

## Problem

In a distributed environment, calls to remote services and resources can fail
due to transient problems, such as slow network connections, or overused
resources, such as a database or application server. These failures are usually
fixed automatically after a short period of time, however this can negatively
impact the integration application.

## Solution

There is a very simple way to prevent the application from impacting the
environment where it is being executed, using timeout. Timeout is a simple
defense mechanism that prevents unlimited wait times for responses.

If the timeout time is reached, an exception will be generated for the
application or the consumer to handle.

Timeouts are used in almost all applications to prevent requests from being
blocked forever. However, dealing with timeouts is not trivial. Imagine an order
timing out on an online store. You may not be sure if the order was successfully
placed, if order creation was still in progress, or if the request was never
processed. If you combine the timeout with a retry, you could end up with a
duplicate order. If you mark the order as failed, the customer might think the
order was unsuccessful, but maybe it was and they will be charged. Also, you
want your timeouts to be high enough to allow for slower responses, but low
enough to stop waiting around for a response that will never arrive.

In the integration scenario example, the timeout will be configured as a service
consumer and will be detailed at [How To configure timeout with httpcomponent](../../how-to-guides/execution-and-runtime/timeout.md)
