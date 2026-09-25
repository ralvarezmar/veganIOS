---
title: Fixes and improvements in Back components scaffolding
categories:
  - Back
date:
  created: 2025-08-14
tags:
  - Fix
  - Improvement
---

![Fix](../assets/images/fix-blog.png){width=100%}

### What's Changing?

We have fixed and improved the scaffolding in the following components:

* Santander Spring Boot Library
* Arsenal Microservice
* Arsenal Library
* Darwin Java Library
* Darwin NodeJS Microservice
* Darwin Python Microservice

These changes include, among others:

* Fixed application name validation in Darwin NodeJS archetype (INC056393952). Application short name can now start with a number or letter.
* Fixed runAsUser value in default SecurityContext for Darwin NodeJS and Darwin Python Microservices.
* Updated Darwin Python Microservice archetype version to v4.1.6.

### Why Is This Important?

These fixes and enhancements will provide more stability and compatibility with future updates in the Gluon platform, ensuring that developers can scaffold their components with the latest capabilities.

### How to Use This Feature?

Users do not need to take any specific action to benefit from these improvements. The fixes will be automatically applied when scaffolding new components using the affected archetypes.
