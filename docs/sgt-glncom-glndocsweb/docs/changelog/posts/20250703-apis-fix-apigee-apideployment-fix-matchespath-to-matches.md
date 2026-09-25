---
title: Fixed error when consuming APIs deployed in Apigee that contained operations at root level of the basePath
categories:
  - APIs
date:
  created: 2025-07-03
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

When publishing APIs in Apigee, there was an issue when the API definitions included an operation "/", resulting in a 404 error when consuming them.

When deploying an API in APIGEE, the `MatchesPath` expression was used to distinguish the various resources and operations of an API.
It was detected that this expression is unable to correctly resolve paths that do not have a clearly defined resource, such as "/". Therefore, the `MatchesPath` expression is replaced with `Matches`.

### Why Is This Important?

The modification ensures that paths without a clearly defined resource, such as "/", are correctly resolved, guaranteeing that the API operations work properly and all resources can be distinguished.
