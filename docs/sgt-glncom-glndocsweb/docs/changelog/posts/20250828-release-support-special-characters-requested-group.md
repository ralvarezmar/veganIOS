---
title: Release Management Fix, Support special characters in Requested Group
categories:
  - Release
date:
  created: 2025-08-28
tags:
  - Fix
  - Improvement
---
 
![Fix](../assets/images/fix-blog.png){width=100%}

### Problem Description

 When creating a new release, when adding a `Requester Group` which contained special characters (like accents, symbols, etc.), an error occurred preventing the release from being created.

### What's the solution?

The system has been updated to properly handle special characters in the `Requested Group` field during release creation. Now, users can input group names with special characters without encountering errors.
