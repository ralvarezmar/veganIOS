# Unit Tests

This session is intended to provide a path to guide projects to address issues related to unit testing that may be impacting the local environment or treadmill.

## 🎯 Overview

Problems running unit tests can occur for the following reasons:

- Lack of knowledge on how to implement unit tests;
- **Implementation** of unit tests that **do not follow good practices** and generate **performance and asynchronicity issues;**
- **Incorrect configuration of the environment** for executing unit tests;

## 📋 Initial Checklist

Before proceeding to the mapped scenarios that we have documented, follow the checklist to do a recap of the procedure required for using external libraries and dependencies:

- [ ] Delete the ***node_modules*** from the project;
- [ ] Switch to the version of ***Node*** that is compatible with the version of ***Angular***;
- [ ] Install project dependencies via the 'npm install' command;
- [ ] Run the 'npm run test' command at least three times;

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most resembles yours:

### **npm run test** command failed on local machine

The problem may be the implementation of the unit tests themselves. In such cases, the problem must be identified and corrected. Documented possible solutions to this issue are:

- [How to resolve the 'is not a known element' error](./is-not-a-know-element.md)
- [How to solve the "Expected to be running in 'ProxyZone', but it was not found."](./expected-to-be-running-in-proxyzone-but-it-was-not-found.md)

### **npm run test** command burst

The problem may be the implementation of a specific test or configuration that is impacting the other tests. This can occur due to synchronicity issues due to poor test writing or misconfiguration of the environment.

Documented possible solutions to this issue are:

- [Chrome Headless disconnecting after a certain amount of time](./chrome-headless.md)
- [Disconnectedreconnect failed before timeout](./disconnectedreconnect-failed-before-timeout.md)
- [How to solve the "Expected to be running in 'ProxyZone', but it was not found."](./expected-to-be-running-in-proxyzone-but-it-was-not-found.md)

### Tests run successfully on the local machine but **fail on the pipeline**

If the tests pass normally in the development environment, but fail in the wake, we may suspect that some configuration associated with the environment is influencing it in some way.

Documented possible solutions to this issue are:

- [Test Environment Equalization](./equalize-environments.md)
- [Please set env variable CHROME_BIN](./chrome-bin.md)
- [Disconnectedreconnect failed before timeout](./disconnectedreconnect-failed-before-timeout.md)
