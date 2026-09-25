---
title: Deploy button now correctly enabled within valid deployment windows
categories:
  - Release
date:
  created: 2025-10-23
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What is changing?

Previously, the deployment window logic was applied incorrectly, causing the **Deploy to Production** button to be **disabled even during valid deployment windows**.
 This behavior has now been corrected. The button will now enable or disable **strictly based on the configured deployment window**.

### Why is this important?

This fix removes an unnecessary blocker that sometimes **prevented valid Production deployments**, restoring **predictable and reliable release operations**.
