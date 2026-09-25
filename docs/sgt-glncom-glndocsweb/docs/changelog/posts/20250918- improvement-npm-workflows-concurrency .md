---
title: Added concurrency limit to NPM workflows to cancel previous runs if a new one is started
categories:
  - Release
date:
  created: 2025-09-18
tags:
  - Improvement
---

![Fix](../assets/images/improvement-blog.png)

### What's Changing?

NPM workflows are now set up to automatically cancel any previous runs when new changes are pushed to an open pull request. This prevents outdated executions and ensures that only the latest changes are processed.

### Why Is This Important?

This update streamlines workflow management by ensuring that only the latest workflow execution runs, while outdated runs are automatically cancelled. This improves clarity for developers and optimizes resource usage by preventing unnecessary executions.
