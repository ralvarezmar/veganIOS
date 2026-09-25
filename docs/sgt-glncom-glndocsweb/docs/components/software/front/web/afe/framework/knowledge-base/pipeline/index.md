# Pipeline (CI/CD)

This session is intended to provide a rocky path to guide projects to solve problems encountered during the execution of the DevOps CI/CD pipeline.

## 🎯 Overview

Problems running the pipeline can happen for the following reasons:

- Improper configuration;
- Failure in unit tests;
- Error in the compilation of the project;

## 📋 Initial Checklist

Before proceeding to the mapped scenarios that we have documented, follow the checklist to do a recap of the procedure required for using external libraries and dependencies:

- Run the 'npm run build' and 'npm run test' commands locally, to make sure they are working properly;
- Turn the pipeline at least twice to make sure it does not flicker;
- Analysis of the pipeline logs;

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### Sonar Static Analysis Step Failed

Documented possible solutions to this issue are:

- [Sonar](./sonar/index.md)

### Failure during **PAAS deployment**

Documented possible solutions to this issue are:

- [PAAS (Openshift)](./paas/index.md)
