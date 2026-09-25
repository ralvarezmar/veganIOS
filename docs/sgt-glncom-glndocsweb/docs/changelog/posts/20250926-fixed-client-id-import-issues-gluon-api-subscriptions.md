---
title: Fixed Client Id Issues in Gluon API Subscriptions
categories:
  - APIs
date:
  created: 2025-09-26
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

1. **Client-id import now works smoothly in Apigee:** You can now import a client-id in Apigee client migration subscriptions if it already exists in API Manager, without errors.
2. **Correct handling of missing client-id values:** When using older API Subscription components that don't specify the client-id parameter for a particular environment,
the system now correctly uses the default client-id when registering with the Authorization Server

### Why Is This Important?

With these improvements, you can manage your API subscriptions with greater confidence and less hassle. You’ll avoid errors when importing client-ids.
