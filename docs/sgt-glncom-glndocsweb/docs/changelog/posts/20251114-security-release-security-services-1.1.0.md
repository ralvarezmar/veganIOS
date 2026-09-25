---
title: Gluon Vault, New Role for Reading Secrets in Non-Onboarding Applications
categories:
     - Security
date:
     created: 2025-11-14
tags:
     - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

We are introducing a new role in Gluon HashiCorp Vault that grants read access to secrets for applications that are not onboarded.

### Why Is This Important?

This change allows not onboarded applications to access global secrets without requiring each application to be onboarded.
The new role simplifies access to common secrets.

### How to Use This Feature?

No action is required on your part. The new role is automatically assigned to not onboarded applications,
enabling them to read secrets from designated folders without additional configuration. Additionally,
any company onboarding a new application will have this role assigned by default.
