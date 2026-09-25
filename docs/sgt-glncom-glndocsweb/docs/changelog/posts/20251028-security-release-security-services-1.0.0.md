---
title: Gluon Vault, Admin Audit Logs and Read Permissions Improvement
categories:
     - Security
date:
     created: 2025-10-28
tags:
     - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

- We are adding to Gluon users the capability to admin audit logs in Gluon Hashicorp Vault.
- The roles that are created by application and environment to allow access from pipelines to Vault secrets are given the ability to read from the following folders:
  - /global/ci-tools/*
  - /COMPANY/ci-tools/*
  - /COMPANY/APPLICATION/ci-tools/*
  - /COMPANY/gluon-platform/*

### Why Is This Important?

- This change enhances security by enabling Gluon users to manage audit logs effectively, ensuring better monitoring and compliance.
- By granting specific read permissions to roles, we allow to read secrets without environment, facilitating smoother operations in CI/CD pipelines while maintaining security protocols.

### How to Use This Feature?

- Gluon users can now access and manage audit logs in Gluon Hashicorp Vault through the vault interface or command line tools.
- The pipeline developers can utilize the newly assigned read permissions to access necessary secrets from the specified folders without needing to specify the environment, streamlining their workflow.
