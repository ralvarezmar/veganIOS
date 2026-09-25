---
title: Rollback deployment to PRO no longer skips when the target version has already been deployed
categories:
  - Release
date:
  created: 2025-10-29
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What is changing?

Previously the rollback process was not evaluating correctly if a version needed to be redeployed. The experience was that some components that required to be deployed were not returned to the previous version with the rollback.
 Current fix determines properly which component needs to be deployed into a rollback execution to return the application to the previous state.

### Why is this important?

This fix **removes a blocker that prevented a valid rollback execution** because the version to deploy had been deployed in the previous release.
