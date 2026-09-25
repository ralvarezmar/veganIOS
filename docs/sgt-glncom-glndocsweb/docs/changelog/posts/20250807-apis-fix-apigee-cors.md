---
title: Fixed error when consuming APIs deployed in Apigee CORS heaaders were not correctly returned.
categories:
  - APIs
date:
  created: 2025-08-07
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

When publishing APIs in Apigee, there was an issue when consuming the OPTIONS method, client_id was required before returning the CORS headers.

CORS apigee policy has been replaced to not require clientId when making a request to the OPTIONS method.

### Why Is This Important?

The modification ensures that CORS policy is correctly used in all use cases, guaranteeing the API operations work properly.
