---
title: Ephemeral Runners selected as default when creating an OnDemand Configuration
categories:
  - Testing
date:
  created: 2025-09-11
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

In the Gluon Testing service, there was a bug that allowed the user to bypass the selection of cloud configuration, hence corrupting the configuration and rendering it useless.

### What's Changing?

From now on when the user reaches the cloud configuration part of an OnDemand creation, the Ephemeral Runners option will be selected by default, making it impossible for the user to continue the process without selecting an option.

### Why Is This Important?

It prevents the creation of corrupt configurations and avoids potential user confusion and frustation.
