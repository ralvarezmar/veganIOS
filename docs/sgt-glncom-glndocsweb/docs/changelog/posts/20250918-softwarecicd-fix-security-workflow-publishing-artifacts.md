---
title: Fixed Logic error in security workflow publishing artifacts
categories:
  - Software CICD
date:
  created: 2025-09-18
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

We've resolved the logic problem in the security workflows.
Security workflows should not publish artifacts. The same way as it is
for images

**Technical Changes:**

- Added a rule to not publish artifacts if it is a security execution

**Problem Impact:**

- Unnecessary publishing of artifacts in the security workflows

**Benefits of the Fix:**

- **Performance improvement**: No execution of unnecessary steps
