---
title: Remove Quality Gate validation after each new baseline
categories:
  - Quality
date:
  created: 2025-07-21
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

Due to the brownfield, some components are migrated using a different Quality Gate than the one the technology they belong has assigned.

### What's Changing?

Previously, after each new baseline set up, the Sonar Provisioning API would check if the Quality Gate of the project was the same as the one configured for that technology.
If there was a mismatch it would update the Quality Gate in Sonar with the one from the technology.
This comprobation has been removed, so it will no longer check the Quality Gate when setting a new baseline.

### Why Is This Important?

This fix is necessary for the brownfield.
