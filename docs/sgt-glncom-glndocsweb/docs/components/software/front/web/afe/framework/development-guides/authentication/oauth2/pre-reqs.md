# Pre-reqs

In this step, we will address the necessary prerequisites for implementing the module in the project.

## Non-functional

Pertinent understanding of terms, information and details associated with the flow used to build the module, for this, consult the sections and sub-sessions of the following documentation:

- **Solution Architecture**:
  - [Authentication](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=587669809)
- **Technical Arch - Integration and Streaming**:
  - [Apigee Reference Architecture](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257388220)
  - [Authorization Code Flow](https://confluence.santanderbr.corp/display/PADROESARQINT/Fluxo+Authorization+Code)
  - [Authorization Code](https://confluence.santanderbr.corp/display/PADROESARQINT/Authorization+Code)
- **Security Solutions**:
  - [Browser Authentication (via Authorization Code)](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=333862072)

## Functional

Before implementing it on the frontend, it is necessary to have verified the functional aspects associated with the process, according to the following considerations:

- Has the authentication been validated with the [Solution Architecture](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=118710389) team against the business need?

- Did you get the application credentials (ClientID and ClientSecret) through the Developer APP execution conveyor?

- Have you obtained consumption permission for the flow APIs?

- For authentication, request permission to **APIGEE Product GHS - Authentication OAuth Client**

- For encryption, request permission for **APIGEE Product DLB - Cryptographic Security**

- Have you aligned with the [OA2](https://confluence.santanderbr.corp/display/SOLSEG/OA2) team of [Security Solutions](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666642) for registration and necessary application configurations?

> Credit needs and API consumption can be checked at:
>
> - [Request to create a Developer App or consume it in Apigee](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=320908924)

## Installation

### Library ***@afe/authentication***

Install the library responsible for authentication.
> Install a version that is comparable to the version of Angular that your project is in.

```bash
npm install @afe/authentication^2 @afe/event-handler^2
```

***Notes***

> Due to the ***Inherited*** module of the part (for listening and event emitting purposes), it is necessary to install the ***@afe/event-handler*** library as well.
