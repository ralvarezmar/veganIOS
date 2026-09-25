# Errors management in Santander Java microservices

## Processing http services in microservices

The result of process an http request that arrives at a microservice can be:

- That the request is processed correctly. As a result, the microservice will return the data or make the requested changes to server resources.
  The response should indicate to the caller that the operation has completed properly through its http response code.
- That the request cannot be processed, in which case the microservice must indicate this to the caller through an http response code and returning a message in the body that allows it to identify the source of the error and respond accordingly.

When the microservice cannot process the request, it can be for two different reasons:

1. An error has occurred in the processing carried out in the server microservice:
   a communication failure, lack of resources of the micro itself or one of its dependencies, undetected coding errors.
2. An error has occurred derived from the data sent by the client: credentials are missing, the input format is not as expected or one of the input fields does not have a valid value,
   the user does not have permissions to perform the requested operation, the resource does not exist, etc.

## Http status codes

Http response codes must be in accordance with those specified in [API standards - HTTP Status Codes](../../../../api/framework/standards/design/statusCodes.md).

## Error message

The error format must conform to [API standards - Error structure](../../../../api/framework/standards/design/error.md).

## Error handling in the calling microservice

When a microservice implements a call to another microservice via http, it must be able to process the code and body of the response not only when the request is properly processed, but also when the request ends in an error. To do this,
 you must know the possible error codes of the invoked services.

### 5xx error processing

When the calling microservice receives codes in the 5xx range, it will be because the called service cannot process the request due to internal causes.

These errors could be punctual, so the use of retries could allow us to end up giving an adequate response.

In the event that the caller receives this type of response, they should:

- Retry the call
- Log the error in the call with ERROR level, the logged message should contain the body of the error message returned by the service.
- If it is possible to give a fallback that allows a sufficient response, in case it is not possible to return a 5xx type error to your client.
- When errors are repeated despite retries, it is because the cause persists over time. In that case the caller should implement the Circuit Breaker pattern to prevent the fault from affecting its own stability.

### 4xx error processing

When the calling microservice receives codes in the 4xx range, it will be because the called service has encountered a problem with the data sent in the request that has prevented it from processing the request.

The causes can be two types:

- "Functional" errors the operation is not carried out for a functional reason, there is no balance, the user is not authorized to carry out the operation, etc...
- Technical errors in the calling microservice, this could be due to undetected coding errors during the testing phases or configuration issues in the runtime environment.

Due to their nature, these errors will be persistent, so in that case it makes no sense to retry with the same data, nor does it make sense to apply the Circuit Breaker pattern, since requests with some data may not be processed properly
 but with other data, yes, with what the opening of the "circuit" would cause to fail to requests that if it is possible to process correctly.

In this type of errors, the caller should:

- Analyze the body of the error message and, based on the errorName or httpMessage code, identify the type of error produced and act accordingly.
    - If the error is identified as a functional error, write to the log with a WARNING level containing the body of the response error message.
    - If the error is identified as technical, wrong url, malformed syntax, write to the log with ERROR level containing the body of the response error message.
    - In both cases, it is recommended to trace the data of the call to the service in DEBUG mode.
- If possible, give a fallback that allows a sufficient response to be given, if this is not possible, return a 4xx type error to your client, indicating the reason for the error in the body.
