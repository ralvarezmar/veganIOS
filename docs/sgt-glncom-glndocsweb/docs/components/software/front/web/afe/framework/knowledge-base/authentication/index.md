# Authentication

This session is intended to provide **information and guidance for issues encountered during configuration and authentication in applications.**

## 🎯 Overview

Errors related to architecture libraries can be related to:

- Lack of definition of the authentication solution that will be used by the application. In these scenarios.
- It is necessary to contact [solution architecture](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=320902139) to understand which authenticator method the application needs to consume.
- Implementation or misconfiguration of authentication. This scenario applies when there is **inattention in reading** or there is **absence of information** in the documentation.
- Lack of permission to consume the authenticator APIs.

## 📋 Initial Checklist

Before proceeding to the mapped scenarios we have documented, follow the checklist to do a recap of the procedure required to implement the configuration:

- [ ] Contact the [Solution Architecture](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=320902139) team if you don't know **what an authenticator method is** or **what authenticator method will be used** by the application.
- [ ] **Request permission from the authenticator API** that will be consumed by your application, via [opening a call on CDG](https://jira.santanderbr.corp/projects/SCDGHUBBR/).

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### Authentication Issues **Single Sign ON (SSO)**

Documented possible solutions to this issue are:

- [How to troubleshoot "SPNEGO authentication is not supported on this client"](./sp-nego.md)

### Apigee Reference Authentication

- [Routing pertinent to the referral authentication flow](./referral.md)
