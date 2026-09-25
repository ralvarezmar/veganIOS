# Security

This session aims to provide guidance for issues related to application security and vulnerabilities.

## 🎯 Overview

Security-related errors can happen due to:

- **Vulnerable libraries** installed in the project;
- Absence of security headers configured by the project;
- **Issues related to IQ Server**;

## 📋 Initial Checklist

Before proceeding to the mapped scenarios that we have documented, follow the checklist to do a recap of the procedure required for using external libraries and dependencies:

- Verify that the security headers are configured correctly via [CDG ticket opening](https://jira.santanderbr.corp/projects/SCDGHUBBR/);

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### Failed to consume **resources and APIs**

Documented possible solutions to this issue are:

- [How to troubleshoot "blocked-csp"](./blocked-csp.md)
- [How to resolve "Path-Based Vulnerability" of "GZIP" archive](./path-based-vulnerability.md)
- [How to troubleshoot "IFA (Sensitive Files Disclosure)"](./ifa-sensitive-files.md)
- [How to change the HTTP header "Strict-Transport-Security"](./http-strict-transport-security.md)

### **IQ Server** Issues

Documented possible solutions to this issue are:

- [How to troubleshoot issues with transitive AFE dependencies](./dependencies.md)
