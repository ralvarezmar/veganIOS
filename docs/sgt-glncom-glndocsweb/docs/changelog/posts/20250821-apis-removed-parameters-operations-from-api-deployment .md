---
title: Fixed error when generating APIs deployments with parameters common to all verbs in the same path in the API definition.
categories:
  - APIs
date:
  created: 2025-08-21
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

When creating API deployment components, there was an issue when the definition had common parameters defined in the same path, generating in Gluon operations with "parameters" as a verb.

Scaffolding and ADM have been change to avoid this situation and only generating operations for http verbs.

### Why Is This Important?

The modification ensures that Gluon API Deployments are fully compliant with OpenApi 3 standard definitions.
