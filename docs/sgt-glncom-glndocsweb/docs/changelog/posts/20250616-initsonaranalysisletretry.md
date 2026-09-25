---
title: Error when retrying the scaffolding and the sonar init action has already been executed successfully
categories:
  - Management
date:
  created: 2025-06-16
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png){ width=100% }

Makes an improvement in scaffolding workflow to allow retries whatever problem occurs later.

### What's Changing?

- We regard the version of the empty analysis and check that is already launched.
- During scaffolding we are going to get only the info related to sonar onboarding and no for security onboarding.

### Why Is This Important?

In the scaffolding workflow, when a step after the initial Sonar analysis fails, the initial analysis is already created in Sonar and if the user retries the scaffolding, he cannot execute the initial analysis since it already exists.
