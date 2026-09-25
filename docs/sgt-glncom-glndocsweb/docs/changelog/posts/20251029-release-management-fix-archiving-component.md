---
title: Release creation now supports archived components
categories:
  - Release
date:
  created: 2025-10-23
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What is changing?

Previously, Gluon Releases failed when handling components marked as archived in the OAM (Open Application Model) file. With this update, releases can be created even if a component has been archived, and the archived status is correctly respected.

### Why is this important?

This resolves an error that blocked release creation whenever an archived component was present. Supporting the archived field improves reliability, avoids unnecessary publication failures, and aligns the workflow with current component lifecycle practices.
