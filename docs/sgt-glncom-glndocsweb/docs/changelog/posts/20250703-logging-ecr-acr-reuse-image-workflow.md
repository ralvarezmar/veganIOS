---
title: Error in reuse image workflows when logging into ACR and ECR when using multiple different accounts simultaneously.
categories:
  - Software CICD
date:
  created: 2025-07-03
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png){ width=100% }

Makes an improvement in the retag function to resolve the issue.

### What's Changing?

- When execute release workflow of reuse image, in the Retag release image job we use the correct credentials for each account.

### Why Is This Important?

In the release workflow of reuse image, we upload the images correctly to each of the environments.
