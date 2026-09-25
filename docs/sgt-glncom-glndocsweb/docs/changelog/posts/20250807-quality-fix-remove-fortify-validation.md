---
title: Eliminate component onboarding validations from Security tools in quality workflows
categories:
  - Quality
date:
  created: 2025-08-07
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

Currently, when the quality workflow is executed, it is validated whether the component is correctly onboarded in SonarQube, and it is also being validated whether it has been onboarded in the Security tools.

### Why Is This Important?

It is important to eliminate unnecessary validations, and if the Security tool was not operational, the quality workflow was blocked.
