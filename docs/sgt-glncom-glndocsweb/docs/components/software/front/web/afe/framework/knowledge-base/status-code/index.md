# HTTP Status Codes

This session is intended to provide guidance for the status codes of completed requisitions. The answers are grouped into five classes:

## 🎯 Overview

HTTP errors can happen to any requests in an application. They can have the following origins:

- Information responses (100-199)
- Successful responses (200-299)
- Redirects (300-399)
- Client errors (400-499)
- Server errors (500-599)

## 📋 Initial Checklist

Before proceeding to the mapped scenarios that we have documented, follow the checklist to do a recap of the procedure required for using external libraries and dependencies:

- [ ] **Identify the error status code**. Server errors are usually not problems in the implementation.
- [ ] **Check the call implemented on the front-end** and get from the request response if **any header or information is missing from the payload.**

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### Client-side errors

Documented possible solutions to this issue are:

- [How to troubleshoot "***401 not authorized***"](./401-not-authorized/index.md)
- [How to troubleshoot "***403 forbidden***"](./403-forbidden/index.md)
- [How to troubleshoot "***412 precondition failed***"](./412-pre-condition-failed.md)
