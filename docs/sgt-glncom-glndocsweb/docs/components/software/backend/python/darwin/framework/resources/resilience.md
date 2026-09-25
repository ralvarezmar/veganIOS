---
title: Resilience
---

## Introduction

Resilience is an important aspect of software development, especially when it comes to building robust and reliable systems. In this article, we will explore various techniques and best practices for implementing resilience in Python applications.

## Retry Strategies

In scenarios where failures are expected or temporary, implementing retry strategies can help improve the resilience of your Python application. There are different types of retry strategies, such as exponential backoff, fixed delay, and jittered delay.
These strategies can be implemented using libraries like `retry` or by writing custom retry logic.

The retry pattern is a technique used in software development to handle failures or temporary errors that may occur during the execution of a program.
It is particularly useful in scenarios where network requests, database operations, or external service calls are involved.

The main idea behind the retry pattern is to attempt the operation again after a failure, instead of immediately giving up.
By retrying the operation, you increase the chances of it eventually succeeding, especially if the failure was due to a transient issue.

There are several reasons why developers use the retry pattern:

- **Resilience**: The retry pattern helps improve the resilience of your application by allowing it to recover from failures automatically. Instead of crashing or throwing an error, the application can retry the operation and continue functioning.

- **Fault tolerance**: By implementing retry strategies, you can make your application more tolerant to temporary failures.
For example, if a network request fails due to a momentary network glitch, the retry pattern can help ensure that the request eventually goes through.

- **Reduced manual intervention**: Without the retry pattern, developers would need to manually handle every failure scenario and implement the logic to recover from them.
By using the retry pattern, you automate this process and reduce the need for manual intervention.

- **Handling rate limits**: Some APIs or services impose rate limits to prevent abuse. In such cases, the retry pattern can be used to handle rate limit errors by waiting for a specific duration before retrying the operation.

Overall, the retry pattern is a powerful technique for building robust and reliable Python applications by handling failures gracefully and improving the overall resilience of your software.

### Tenacity library

The *Tenacity* library exposes a easy-to-use decorator, which allows us to finely tune how and when a function retries.

Here's an example of use:

```py
from tenacity import retry, stop_after_attempt, wait_fixed, wait_random
import random

@retry(retry=retry_if_exception_type(CustomException), stop=stop_after_attempt(10), wait=wait_fixed(3) + wait_random(0, 2), reraise=true)
def function_that_can_fail():
    ###some code
    try:
        if random.randint(0,9) == 0:
            raise SpecificException()
        else:
            raise CustomException()

    except SpecificException as exc:
        # SpecificException handling
```

This code represents a function that can raise different exceptions randomly. In this case, we want to continue trying to execute the function until the *SpecificException* is raised.

We decorate the function with *@retry*, and fill its parameters to our desires:

- **retry**: The exception that the retry decorator catches. When it is raised and not handled, the function is executed again. Can also be configured to retry depending on the result of the function.
- **stop**: The maximum number of retries that the function is executed, or the maximum time amount spent retrying.
- **wait**: Time in seconds between retries, in this case, random from 3 to 5 seconds.
- **reraise**: Either rise the same exception as the one in the code, or raise a retry-related exception.

Therefore, in our example, our function will be executed until it raises a SpecificException or until it executes 10 times. Each time it is executed, it waits 1 second more before trying again, up to 5 seconds waiting.

## Circuit Breaker Pattern

The circuit breaker pattern is another useful technique for building resilient systems. It helps prevent cascading failures by temporarily blocking requests to a service that is experiencing issues.
Python libraries like `circuitbreaker` provide easy-to-use implementations of the circuit breaker pattern.

The circuit breaker pattern works by monitoring the number of failures that occur when making requests to a service. When the number of failures exceeds a certain threshold, the circuit breaker trips and starts blocking requests to the service.
This prevents further requests from being made to the service until a specified timeout period has elapsed.

There are several reasons why developers use the circuit breaker pattern:

- **Fault isolation**: By blocking requests to a service that is experiencing issues, the circuit breaker pattern helps isolate failures and prevents them from propagating to other parts of the system.
This can help minimize the impact of failures and improve the overall stability of the system.

- **Graceful degradation**: When a service is experiencing issues, it may not be able to handle requests effectively.
By blocking requests to the service, the circuit breaker pattern allows the system to gracefully degrade and continue functioning without relying on the faulty service. This can help maintain a certain level of functionality even in the presence of failures.

- **Reduced resource consumption**: When a service is experiencing issues, making repeated requests to it can consume valuable system resources.
By blocking requests to the service, the circuit breaker pattern helps conserve resources and prevent further strain on the system.
This can help improve the overall performance and efficiency of the system.

- **Automatic recovery**: After a specified timeout period has elapsed, the circuit breaker pattern allows requests to the service to be retried. This provides an opportunity for the service to recover and resume normal operation.
By automatically retrying requests, the circuit breaker pattern helps ensure that the system can quickly recover from failures and resume normal functionality.

Overall, the circuit breaker pattern is a powerful technique for building resilient systems by preventing cascading failures, isolating faults, and providing graceful degradation.

### Circuit breaker in Darwin

Darwin python uses the circuit breaker pattern in its own modules, using the *circuitbreaker* library.
This pattern is used when calling external services. This can be seen in *Darwin security*, as it calls either a public key manager service or in a jku call.

### Circuitbreaker library

In Darwin python, we use the base *circuitbreaker* library. It exposes a easy-to-use decorator, which allows us to finely tune how and when a function breaks and eventually retries again.

Here's an example of use:

```py
from circuitbreaker import circuit

@circuit(failure_threshold=10, recovery_timeout=40, expected_exception=SpecificException)
def function_executed_multiple_times():
    if random.randint(0,9) == 0:
        # (for example) some code that uses a lot of resources
        raise SpecificException()
    else:
        ##normal code execution
```

This code represents a function that is called often in the code, and can sometimes raise an exception. For the sake of the example, let's say that raising an exception consumes too many resources. We don't want that to happen that often.

We decorate the function with the *@circuit* decorator, and fill its parameters to our desires:

- **failure_threshold**: number of executions that can raise an exception before changing to an *open* state. An *open* state does not allow executions.
- **recovery_timeout**: Time spent in an *open* state. After said time, switches to a *half-open* state, allowing for one test execution. If it fails, goes back to the *open* state. Succeeding sets it to *closed*, and the failure count is reset.
- **expected_exception**: Exception to listen for in order to count failures. Other exceptions are ignored.

Therefore, whenever the function is executed and it raises the *SpecificException*, the failure count increases.
After 15 failures, the circuit opens and prevents the execution of the function for 40 seconds.
Following that, it does a test execution. Depending on if the execution fails or not, the circuit opens or closes, respectively.

## Retry and Circuit Breaker combined

In some scenarios, it may be beneficial to combine the retry and circuit breaker patterns to further enhance the resilience of your Python application.

By combining these two patterns, you can achieve the following benefits:

- **Enhanced fault tolerance**: The retry pattern helps handle temporary failures by retrying the operation, while the circuit breaker pattern helps isolate faults and prevent cascading failures.
By using them together, you can enhance the fault tolerance of your application by quickly recovering from temporary failures and preventing them from propagating to other parts of the system.

- **Improved resource management**: The circuit breaker pattern helps conserve system resources by blocking requests to a faulty service.
By combining it with the retry pattern, you can further optimize resource management by avoiding unnecessary retries when the service is already experiencing issues.
This can help improve the overall performance and efficiency of your application.

- **Fine-grained control**: By combining the retry and circuit breaker patterns, you can have fine-grained control over how and when retries are performed.
For example, you can configure the circuit breaker to open after a certain number of failures and then use the retry pattern to retry the operation only when the circuit is closed.
This allows you to tailor the behavior of your application based on specific requirements and conditions.

- **Increased resilience**: The combination of the retry and circuit breaker patterns can significantly increase the resilience of your application.
By handling temporary failures with retries and isolating faults with the circuit breaker, you can ensure that your application can recover from failures and continue functioning even in challenging conditions.

When combining the retry and circuit breaker patterns, it is important to carefully consider the configuration parameters of each pattern and how they interact with each other.
For example, you may need to adjust the retry delay and maximum number of retries based on the recovery timeout of the circuit breaker.

### Example

```py
from circuitbreaker import circuit
from tenacity import retry, stop_after_attempt

@circuit(failure_threshold=10, recovery_timeout=40)
@retry(stop=stop_after_attempt(10))
def function_executed_multiple_times():
    if random.randint(0,9) == 0:
        # (for example) some code that uses a lot of resources
        raise SpecificException()
    else:
        ##normal code execution
```

This code snippet is written in Python and demonstrates the use of two different libraries: circuitbreaker and retry.

The @retry(tries=10) decorator is used to retry the execution of the decorated function in case of an exception. In this case, the function function_executed_multiple_times() will be retried up to 10 times if an exception occurs.

The @circuit(failure_threshold=10, recovery_timeout=40) decorator is used to implement a circuit breaker pattern. The circuit breaker monitors the number of failures that occur within a specified threshold.
If the number of failures exceeds the threshold, the circuit is opened and subsequent calls to the function will not be executed for a specified recovery timeout period.

With both decorators combined, if the retry functionality retries the code 10 times and raises the exception in all 10 times, the circuit will open, preventingany execution of the function until the timeout counts down.

## Conclusion

The combination of the retry and circuit breaker patterns can greatly enhance the resilience of your Python application.
By using the retry pattern, you can handle temporary failures and improve the overall reliability of your software.
The circuit breaker pattern helps prevent cascading failures and provides fault isolation, ensuring that failures in one part of the system do not propagate to other parts.

By combining these two patterns, you can achieve enhanced fault tolerance, improved resource management, fine-grained control over retries, and increased resilience.

Carefully consider the configuration parameters of each pattern to optimize their interaction.
Implementing these patterns can help you build robust and reliable Python applications that can recover from failures and continue functioning even in challenging conditions.
