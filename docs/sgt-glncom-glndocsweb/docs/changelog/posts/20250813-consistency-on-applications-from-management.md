---
title: Ensure consistency when retrieving application from Management
categories:
  - Testing
date:
  created: 2025-08-13
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

In the Gluon Testing Portal we detected that, sometimes, when retrieving the applications from Gluon Management some applications were missing while others were duplicated.

### What's Changing?

Now all request for applications done to the Management microservices are using the sort parameter to ensure the consistency of the results.

### Why Is This Important?

The Gluon Testing Portal depends on the list of applications returned from Management to be able to know which configurations can be shown to the users.
If the returned list was missing an application that meant all configurations of that application would not appear to the user.
Also, since that list was cached, if it contained an error the error would persist in subsequent calls.
