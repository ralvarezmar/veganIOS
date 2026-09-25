# Web Core

In this version of Gluon we will offer **Darwin** as reference frameworks **for Angular** application development.
Both frameworks, despite being based on Angular, have small differences in their architecture and the way they propose to develop.

In **this version** of Gluon we propose to new applications to **select one of the two frameworks**, basing this choice on the capabilities that each one offers and the needs of the project.

Gluon's roadmap for the **next version** includes the ability for interoperability between both frameworks so that they **can coexist in the same application**, complementing each other.
The next logical step is the convergence of both frameworks into one, which will not be Darwin, but a new version that takes advantage of the best of both.

Regarding the **React framework**, it is **out of the scope of this version** to offer a Santander framework for React, but it is in the roadmap for future versions.

## Core Libraries

Gluon offers a set of new libraries that fulfill the requirements for the new Security Model and the new Microfront Technical Reference Architecture:

### Security

This new security library provides the Security Context Manager module (also known as SCM) **responsible** for managing workflows to **obtain**, **store**, **refresh** and **inject** the user token in the HTTP requests.

In a Microfront architecture, the SCM module will work together with the HTTP module to handle HTTP requests in a secure way, making this complexity as transparent as possible to microfronts.

Requests from Microfronts will be delegated to their Shell who will be responsible for performing the final request and returning the response (or the error) in a transparent way to the Microfront.

In the case of a native application, the Web Microfront should be wrapped in an intermediate Web Shell responsible for establishing a connection with the Native application and delegating these requests to the native app following this schema:

[Learn more about the Security Context Manager...](security/index.md)

### HTTP Module

The goal of this library is to provide a mechanism that allows Microfronts to perform requests in a transparent way.

[Learn more about the http library..](http/index.md)
