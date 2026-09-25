# Header configuration

Headers are additional information that can be sent in the request or response to an HTTP request, allowing the client and server to communicate with each other and are of utmost importance to the security of an application.

Within the **Santander** environment, the configuration of the ***headers*** is essential for the applications to work in the **development**, **homologation** and **production** environments.

> **🎓 Why don't we need to set up headers locally?**
>
> During local development we use the [**proxy configuration**](../../local-environment/proxy.md), which through the ***secure*** property, disables the verification of ***headers*** during requests in order to **make development less bureaucratic**.

**🎓 What will you learn?**

- [CSP (Content Security Policy)](./csp.md)
- [Coexistence between ***ZUP*** and ***Apigee***](./zup-apigee.md)
