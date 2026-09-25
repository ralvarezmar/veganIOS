# @santander/http

## Functional overview

HTTP module overrides default request behavior of the microfront to rely on the shell, by using custom events.
In the case of mobile, a shell wrapper will delegate the request by using an injected function by the native app into his webview, and expect the response in a custom event launch by the native app.

The Microfront sends a custom event called `HTTP_EVENT` with a `Request` object as payload, and a `successHandler` and `errorHandler` functions, that the shell is listening.

Once the Shell receives the event, having control over the login status & token from the user, can perform the request with the appropriate security headers and proceed to respond to the micro-front.

![HTTP Module](<../../../assets/images/common/http-hybrid-coms.png>)

## Library details

![Flowchart Security Module HTTP](<../../../assets/images/common/http-hybrid-coms-flow.png>)

<br markdown="1">

### MicroFront

Microfront will implement  `HttpEventHandlerBackendService` within the HTTP module, an implementation of `HttpBackend` that will convert every angular request into a Custom Event `HTTP_EVENT` and dispatch it.

### Web Shell

In the case of an Angular Shell, this response can be handled by angular `HttpClient`, in a shell level when the `HTT_EVENT` is received with the Request object with `successHandler` & `errorHandler` functions.

### Native apps

In the case of native apps, the module expects a `window.zenFunction` to be injected from the native part.

The request will be sent as a *request object* identified with a unique key (UUID) that will be created automatically.
This unique key will be used by the instance of `@santander/http` that runs on the Shell to store the `successHandler` and `errorHandler` functions.

The responses will be returned to the micro-front by calling `HTTP_RESPONSE` with the previously sent unique ID and calling the `successHandler` function with the received data under their IDs.

In case of an error `HTT_RESPONSE_ERROR` custom event will be called, as well, with the response data and request UUID, for `errorHandler` to be called.

<!-- TODO Do not show this section for now...

## Install for React applications

Install the HTTP library for React:

```bash
npm install @santander/http-react
```

### React Micro Front-End

In the file that will perform the request in your Micro Front-End, import the `setupAxiosForMicrofront` and then use the `axios` instance created to execute the HTTP requests.

```typescript
import { setupAxiosForMicrofront } from '@santander/http-react';

const axios = setupAxiosForMicrofront(Axios);

axios.get(`http://localhost:8080/api/clients`); // this request will be converted into a custom event that will be listened by the shell
```

-->
