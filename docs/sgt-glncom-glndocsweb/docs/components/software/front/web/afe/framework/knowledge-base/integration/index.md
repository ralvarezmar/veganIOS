# Integration between gateways

This session aims to provide a path to guide projects to solve problems related to the integration of front-end applications with their services exposed in gateways.

## 🎯 Overview

Problems in the integration between gateways can happen for the following reasons:

- **Lack of configuration of the necessary security headers**;

## 📋 Initial Checklist

Before proceeding to the mapped scenarios we have documented, follow the checklist to do a recap of the procedure required to fix problems that arise during the development cycle;

- Validate on the gateway that the required headers have been configured correctly.

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### **API calls failed**

Documented possible solutions to this issue are:

If your application is experiencing COR issues in the DEV, HK or production environments open a ticket to the [Integration Architecture (CDG)](https://confluence.santanderbr.corp/display/PADROESARQINT) team and request the configuration of headers.

Other possible causes are listed below:

- [Changing attributes of @afe/authentication-managed tokens](./tokens-from-oauth2-flow.md)
- [Missing x-encrypted-object header](./x-encrypted-object.md)
