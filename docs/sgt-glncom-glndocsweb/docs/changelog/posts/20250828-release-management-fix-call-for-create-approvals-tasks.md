---
title: On Release Creation, approval tasks support long approver names
categories:
  - Release
date:
  created: 2025-08-28
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png){width=100%}

### Problem Description

On release creation, approval tasks failed on creation when the approver name was longer than expected by the system.

### What's the solution?

Gluon has been updated to handle longer approver names when creating approval tasks during the release creation process. This ensures that approval tasks are created successfully regardless of the length of the approver names.
