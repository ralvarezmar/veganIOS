---
title: Release Management Fix, Handle release deployment reattempts to deploy in multi-infrastructure environments
categories:
  - Release
date:
  created: 2025-08-28
tags:
  - Fix
  - Improvement
---

![Fix](../assets/images/fix-blog.png){width=100%}

### Problem Description

  In scenarios where a component is deployed in the same logical environment across multiple infrastructures, if there are a subset of the infrastructures where it failed, users were unable to reexecute the release deployment, as the
  process ignored the component redeployment thinking the component version is already deployed in that environment. The system incorrectly reported that the deployment had already been completed, preventing further attempts.

### What's the solution?

  The deployment orchestration logic has been updated to correctly track the deployment status across multiple infrastructures within the same environment. Now, if a deployment fails on one or more infrastructures, users can reattempt the release deployment.

### Things to take into account

  When this scenario happens, and you reattempt the release deployment, the deployment will be done again in all infrastructures related to that environment, not only in the ones where it failed. This will ensure consistency across all infrastructures.
  This change improves the reliability and flexibility of the deployment process in multi-infrastructure environments, allowing users to recover from partial failures without unnecessary complications.
