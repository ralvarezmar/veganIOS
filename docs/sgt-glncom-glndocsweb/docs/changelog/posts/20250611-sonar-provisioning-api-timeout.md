---
title: During Scaffolding timeout regarding Sonar project
categories:
  - Management
date:
  created: 2025-06-11
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png){ width=100% }

At the scaffolding workflow execution there is a moment where the system regard Sonar project info, but due to the current number of groups inside Sonar, this call produces a timeout.

### What's Changing?

- The query to regard which groups are granted to a sonar project we change to add a param to specify the minimum permission.

### Why Is This Important?

This fix will reduce the number of calls between Sonar provisioning API and Sonar itself.
The init analysis launched during scaffolding will reduce its time and will not response with a timeout.
