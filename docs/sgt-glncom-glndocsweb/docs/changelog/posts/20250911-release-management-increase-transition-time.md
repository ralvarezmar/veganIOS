---
title: Fixed errors during release transitions
categories:
  - Release
date:
  created: 2025-09-11
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

The transition from WAITING ACCEPT to PREPRODUCTION and from AUTHORIZE to SCHEDULE will no longer suffer from occasional failures due to synchronization processes with ITSM Service Now.
Previously, these transitions would fail and releases would remain in their starting status (WAITING ACCEPT or AUTHORIZE).

### Why Is This Important?

This fix ensures a more robust release process, eliminating interruptions during status transitions and providing users with a more reliable experience when managing their releases.
