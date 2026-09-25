---
title: Fix Release Management Alter Field Value RequestedBy for Releases Creations
categories:
  - Release
date:
  created: 2025-08-11
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png){width=100%}

### What's Changing?

✅ **Fix: Release Creation RequestedBy Field**  
  We've addressed an issue with the `requested_by` field during release creation:

  - Fixed the handling of user `sys_id` in the `requested_by` field, before we used `u_upn` or `user_mail`
  - Ensured proper user identification during release creation process
  - Improved data consistency in release management workflows

### Why Is This Important?

Accurate user identification is crucial for release management and tracking. This fix ensures that releases are properly attributed totheir
requesters, maintaining accountability and improving traceability in the release management process. The correction of the `requested_by` field
helps maintain data integrity and supports better audit trails for release operations.

### Technical Details

- Field affected: `requested_by`
- Context: Release creation process
- Fix type: Data handling correction
- Impact: Improved user attribution in release management
