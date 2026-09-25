---
title: Improvements into Release Management deployment process
categories:
  - Release
date:
  created: 2025-06-12
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

Improves are made to make the process more robust when transitions depend on the deploymetn activity feedback:

- ⚙️ **Guarantee Transition from Draft to Testing**  
  The flow was adjusted to ensure that, when moving from Draft to Latest, once a deploy is finished, the release automatically advances to Testing, avoiding unexpected blocks.

- 🚦 **Ensure deploy status is synced**  
  Fix in OAM integration process to avoid false positives in deployment (“Already Deployed”), ensuring correct traceability of deployments.

### Why Is This Important?

Deployment is a process that needs to be correctly informed to let the process progress.
