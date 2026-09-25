---
title: Do not set HPA as default for SPAs and Microfronts
categories:
  - Web
date:
  created: 2025-10-28
tags:
  - Fix
---

![Bug Fix](../assets/images/fix-yammer.png)

### What's New?

We have resolved a configuration issue in **Darwin and React component templates** that was automatically setting HPA (Horizontal Pod Autoscaler)
as default for all SPAs and Microfronts, regardless of whether it was actually needed.

### Why is this important?

By removing HPA as a default configuration, we:

- **Empower DevOps teams** to make informed decisions about when HPA is truly necessary
- **Reduce unnecessary resource allocation** and cluster overhead for applications that don't require auto-scaling
- **Improve cost efficiency** by avoiding automatic scaling configurations in environments where they're not needed

## What's Changed?

- Darwin SPA and Microfront templates no longer include HPA configuration by default
- React SPA and Microfront templates no longer include HPA configuration by default
- DevOps teams should manually configure HPA only for applications that require auto-scaling capabilities

This change gives development and DevOps teams control over their infrastructure configuration, allowing them to configure HPA only when it provides real value for the application's scaling needs.
