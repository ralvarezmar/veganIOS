---
title: Disable "Allow administrators to bypass configured protection rules" by default when creating a new production environment.
categories:
  - Software CICD
date:
  created: 2025-07-21
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

We are pleased to announce a new security improvement to prevent **undesired deployments to production by disabling the "Allow administrators to bypass configured protection rules" property** when a new production-like environment is created in GitHub.

### What's Changing?

With this improvement every time we create a new deployment then the producion environment is generated with the can_admins_bypass parameter as false. For certification and preproduction environments
are generated with the can_admins_bypass parameter as true.

Also with this improvement every time we make a new deployment, the production environment named {production}-{environment-name} is generated with the can_admins_bypass parameter as false. For certification ({certification}-{environment-name}) and
preproduction ({preproduction}-{environment-name}) environments are generated with the can_admins_bypass parameter as true.

### Why Is This Important?

With this enhancement, we allow to make sure that the environments are properly configured when they are created.

So we make sure that no irregular deployments to production are made.

### How to Use This Feature?

The configuration of the environments is automatic.

Therefore, to use this feature, a user does not need to change their current behavior.
