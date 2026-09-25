---
title: Disabling manualy workflow rerun for deployments made by Release Management
categories:
  - Software CICD
date:
  created: 2025-07-21
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

We are pleased to announce a new security measure to prevent **accidentals or out of the deployment window deployments by manually** re-running a compomnent's deployment workflows in Gluon.

### What's Changing?

With this improvement, it is not allowed to rerun cd workflows executed the first time from RM.

Instructions to follow to successfully rerun the workflow are displayed in the log.

### Why Is This Important?

With this enhancement, we not allow run irregular deployments are made.

### How to Use This Feature?

The configuration of the environments is automatic.

Therefore, to use this feature, a user does not need to change their current behavior.
