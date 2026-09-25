---
title: Released Deployment Helm Charts
categories:
     - Back
date:
     created: 2025-09-30
tags:
     - Improvement
     - Fix
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

We have released a new version **2.0.2** of **Common Helm Chart**,
**4.1.2** of **Santander Java Helm Chart** and
**1.9.1** of **Composite Helm Chart**

This version includes the following changes:

#### Deployment Helm Charts

We have released the following new versions of deployment Helm Charts:

* Common Helm Chart **v2.0.2**
* Santander Java Helm Chart **v4.1.2**
* Composite Helm Chart **v1.9.1**

With this version, we have implemented the capability to deploy any Gluon Spring Boot-based framework with the same chart. This means that Arsenal, Darwin, and Santander Spring Boot microservices are now deployed using the unified Santander Helm Chart.
We have also updated the composite chart to utilize this unified chart for Arsenal, Darwin, and Santander Spring Boot microservices Image Reuse.

### Why Is This Important?

The new unified chart enables the capability to use Santander Spring Boot framework in image reuse and simplifies the evolution and maintenance of Spring Boot based microservices deployment charts.

### How to Use This Feature?

#### Deployment Helm Charts

The new deployment Helm Charts will be automatically used by every Arsenal, Darwin, and Santander Spring Boot deployment.
