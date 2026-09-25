---
title: Fixed releases stop transitioning when reaching the Authorize state.
categories:
  - Release
date:
  created: 2025-10-16
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What is changing?

Eventually, when a release was processed by Release Management and reached the *Authorize* state, an error message was displayed and the release did not continue to the desired *Implement* state.
 Adjustments have been made to ensure that releases now transition correctly to the *Implement* state as intended.

### Why is this important?

This change removes a blocker in the release process. If a release remains in the Authorize state and does not reach the Implement state, the deploy button is not enabled and deployment to production cannot proceed.
