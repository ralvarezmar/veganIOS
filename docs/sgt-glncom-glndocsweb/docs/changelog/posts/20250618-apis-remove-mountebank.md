---
title: Remove API Virtualization Functionality with Mountebank
categories:
  - APIs
date:
  created: 2025-06-19
tags:
  - Retired
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

The API virtualization functionality using Mountebank is being removed due to the discontinuation of the product,
which causes vulnerabilities in the product itself because new versions are no longer being released to address them.

Alternatives to Mountebank are being analyzed to provide API virtualization capabilities.

### Why Is This Important?

When downloading a Postman collection for an API, it will no longer have the URL of the Mountebank virtualized service configured.

Instead, a default URL will be configured, which users must modify to point to their deployed API.

The functionality to create the Postman collection with request examples is preserved.
