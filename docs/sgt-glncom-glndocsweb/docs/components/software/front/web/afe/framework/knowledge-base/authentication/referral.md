# Targeting pertinent to the referral authentication flow

Projects requiring referral authentication need to first understand the flow and perform procedures with other areas of the architecture before proceeding with frontend implementation.

## Contextualization

Communication with the Services HUB in the reference architecture uses RHSSO as the authentication provider and Apigee as the communication gateway.

The way previously was through the coexistence architecture, which used authentication performed on the legacy gateway (ZUP) to later perform interoperability with the current gateway (APIGEE).

According to ZUP's decommissioning since 2021, requests and adjustment needs associated with coexistence are currently being barred, requiring the project to adapt to reference authentication.

AFE provides frontend structuring for common needs at Santander.

We have not yet published a guide containing the step-by-step implementation of the @afe/authentication library that will be responsible for the ability to integrate into the reference authentication flow.

However, **the project does not necessarily depend on the structuring AFE for implementation**, it is enough to be guided by the areas involved and documentation made available in confluence.

Alternatively, with the necessary requirements, we can support the implementation of the structuring factor in the project and validate the functional feasibility.

In case of obstacles, align with the team responsible for the authentication flow: [Security Solutions](https://confluence.santanderbr.corp/display/SOLSEG/Suporte).

Therefore, before the project starts the implementation on the frontend, we ask you to check the documentation according to the guidelines below, paying attention to the steps that need alignment with other areas.

## Guidelines

Until now, we have validated two reference authentication flows with Secure Solutions

* [Browser Authentication](https://confluence.santanderbr.corp/display/SOLSEG/Browser+Authentication): logs in through another application (RHSSO) with redirect to the person who requested authentication
* [SSO Ticket](https://confluence.santanderbr.corp/display/SOLSEG/SSO+Ticket): Used when the application receives a token from another app already authenticated for reuse with APIGEE

It is important to understand that the project will **need the credentials of the application in APIGEE**, which will be used in Referral Authentication which can be found in:

[Apigee Architecture - Technical Arch - Confluence | ALM](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257388220), where they mention the concept, process, diagram, and authentication.

Once the application credentials are obtained, it will be necessary to request permission to consume the products of the APIs:

(<https://confluence.santanderbr.corp/pages/viewpage.action?pageId=320908906>) of [Cryptography (Key Exchange)](https://confluence.santanderbr.corp/display/SOLSEG/Troca+de+Chaves) and [Authentication (OAuth)](https://confluence.santanderbr.corp/display/PADROESARQINT/Fluxo+Authorization+Code).

As can be consulted in the documentation [Consumption Authorization Flow Code](https://confluence.santanderbr.corp/display/SOLSEG/Consumo+fluxo+Autorization+Code) available in the:

[OA2 - Security Solutions - Confluence](https://confluence.santanderbr.corp/display/SOLSEG/OA2) session.

> Regarding the need for encryption, AFE provides a step-by-step guide for implementation in your project, which can be consulted at [Angular > Development Guides > Security > How to Implement Encryption](https://afe.paas.santanderbr.pre.corp/docs/angular/guias/seguranca/criptografia)

Since the channel has the necessary APIGEE credentials, API product permissions, registration with the RHSSO (if applicable), then it is possible to proceed with the code implementation in the project.

## Summary

In short, before the project proceeds with front-line implementation, it needs to have:

* Aligned with Solution Architecture to business need
* Obtained credibility of application identification in APIGEE
* Requested permission from the CoG to consume the flow APIs
* Registered the application in the RHSSO (if applicable)
* Registered the intended redirect URL in the RHSSO (if applicable)
* Defined which authentication will be performed [e.g. Customer or Employee] (if applicable)
* Request support from AFE for the implementation of the structuring @afe/authentication
