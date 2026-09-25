# Coexistence between Zup and Apigee

This session aims to provide guidance and answers to the most common problems during the implementation of the coexistence between ***Zup*** and ***Apigee*** through lessons learned.

## 🎯 Overview

All applications that consumed services exposed by ***Zup*** need to migrate their projects, both front-end and back-end, to consume the same services exposed in ***Apigee***. Because of this, a coexistence solution was designed between the two gateways.

Therefore, all the projects below are able to implement the coexistence between Zup and Apigee:

- ✅ Projects that still consume services **only on Zup**
- ✅ Projects that consume services on **Zup and Apigee**
- ✅ Projects that consume services **only in Apigee** (full reference), as coexistence supports both gateways.

## 📋 Initial Checklist

Before proceeding to the mapped scenarios we have documented, follow the checklist to do a recap of the procedure required to verify that the project configuration is correct:

- Request [access to APIs](../../development-guides/authentication/index.md) necessary to implement coexistence;

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### Configuration Issues

Documented possible solutions to this issue are:

- [How to troubleshoot the Authentication Token Returning Null error](./bearer-null.md)
- [How to troubleshoot issues with Renewal Token](./renewal-token/index.md)

### Problems in **consumption**

Documented possible solutions to this issue are:

- [How to Troubleshoot 400 Bad Request Error](./400-bad-request/index.md)
- [How to Troubleshoot 401 Unauthorized Error](./401-unauthorized/index.md)
- [How to troubleshoot the 431 Request Header Fields Too Large error](./431-header.md)
- [How to troubleshoot the 500 Internal Server Error](./500-internal-server-error/index.md)
- [How to troubleshoot the Blocked by CORS Policy error](./cors/index.md)
