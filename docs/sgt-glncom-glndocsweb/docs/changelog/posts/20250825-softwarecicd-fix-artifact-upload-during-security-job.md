---
title: Fixed JFrog Artifact Upload Failure in Security Workflows
categories:
  - Software CICD
date:
  created: 2025-08-25
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

We've resolved a critical issue in the security workflow that was preventing
successful artifact uploads to JFrog repositories when both container images and
artifacts were configured for generation simultaneously.

**Technical Changes:**

- Fixed bugs that prevented uploads when the configured artifact repository is JFrog and not Nexus.

### Why Is This Important?

This fix resolves a **high-severity issue** (Incident INC057739091) that was
causing significant disruptions in the CI/CD pipeline:

**Problem Impact:**

- Security workflows were failing to complete when component templates required
  both image and artifact generation and JFrog is the configured artifact repository
- The impact was specifically restricted to artifact uploads to the Brazilian colleagues' JFrog OnPremise instance

**Benefits of the Fix:**

- **Restored workflow reliability**: Security workflows now complete
  successfully for all configuration scenarios
- **Improved CI/CD stability**: Consistent and predictable behavior across all
  component template configurations
