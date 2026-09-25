---
title: Fix issues in the deployment of API Subscription components created in versions prior to Gluon 7.3.
categories:
  - APIs
date:
  created: 2025-07-03
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

An error is fixed when deploying API Subscription components created in versions prior to Gluon 7.3. Due to this error, it was necessary to execute the update workflow to continue using them.

With the applied fix, it is no longer necessary to execute the update workflow, and the subscription will work in all versions of the API Subscription component created so far.

### Why Is This Important?

In cases where there was a release of old components created months ago, executing the component would generate an error.

Now, they can be deployed without the need to generate a new release.
