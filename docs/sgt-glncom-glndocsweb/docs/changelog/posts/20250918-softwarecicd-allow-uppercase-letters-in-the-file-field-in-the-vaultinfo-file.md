---
title: Allow uppercase letters in the "file" field in the vaultinfo.json file
categories:
  - Software CICD
date:
  created: 2025-09-18
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

Now it is possible to use uppercase letters in the "file" field in the vaultinfo.json file.

### Why Is This Important?

Currently, if the user specifies an uppercase value in the `.values-<environment>.yml` file for the value that links this file to the vaultinfo.json file, the workflow completes as OK, but the secret is created with an empty value in the cluster.

**Problem Impact:**

The secret is created with an empty value in the cluster.

**Benefits of the Fix:**

The secret is created with the correct value in the cluster.
