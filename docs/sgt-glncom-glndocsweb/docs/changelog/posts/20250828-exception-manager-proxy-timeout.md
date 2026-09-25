---
title: Proxy connection timeout on Exception Manager when interacting with ITSM
categories:
  - Testing
date:
  created: 2025-08-28
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

We are improving the configuration of the webclient responsible to interact with ITSM using proxy.

### Why Is This Important?

After some time, there was an error causing a connection timeout when trying to connect to the proxy during requests to ITSM.
This error would only resolve itself for some time when resetting the whole microservice.
This was blocking teams because they needed to open a ticket to ITSM in order to resolve this issue.
This change fixes this connection timeout.
