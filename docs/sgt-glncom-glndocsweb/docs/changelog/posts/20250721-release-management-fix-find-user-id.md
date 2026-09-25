---
title: Fix Release Management User Identification in ITSM
categories:
  - Release
date:
  created: 2025-07-21
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png){width=100%}

### What's Changing?

✅ **FIX: Improved User Identification in Service Now Integration**  

We've resolved an issue with user identification during release creation. Previously, the system was comparing the user's "self" value from the frontend with the "user_name" field in Service Now,
which caused inconsistencies across different countries due to variations in how this field is populated. The system now uses the "u_upn"
(User Principal Name) field instead, which provides reliable user identification without errors.

### Why Is This Important?

Accurate user identification is crucial for release management processes, especially when validating permissions and tracking changes.
 This fix ensures that users across all countries can seamlessly create and manage releases without encountering identification errors,
 improving the overall reliability and user experience of the release management system.
