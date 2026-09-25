---
title: Error when using newman secrets with invalid characters solved
categories:
  - Testing
date:
  created: 2025-10-09
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

The newman workflow failed when using secrets with certain characters such as  `@`, `$`, `&`.
The newman secrets will be escaped to avoid such errors in the future.

### Why Is This Important?

To prevent secrets containing such characters from breaking the workflow execution.
