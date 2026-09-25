---
title: Removal of references to Performance Testing in CICD section of Gluon Testing Portal
categories:
  - Testing
date:
  created: 2025-09-25
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

On Laika Spain there was the option to configure performance tests in the cicd pipeline.
Since Gluon Testing was based on this solution and Gluon does not support this option we removed the possibility to configure performance tests when developing the new Gluon Testing Portal.

Now, with Spain migrating their configurations with Pulse, there was an agreement to also migrate the performance configurations even if those could not be used in Gluon Testing Portal.

Due to this, configuration which had performance tests configured showed extra fields and information in Gluon Testing that should not have been visible in the first place.

We removed or hide all performance references in the CICD section. If your configurations have not been migrated with Pulse you will not see any changes.

### Why Is This Important?

Showing the performance information when it can not be used could induce the users to falsely believe that they can be configured in Gluon.
