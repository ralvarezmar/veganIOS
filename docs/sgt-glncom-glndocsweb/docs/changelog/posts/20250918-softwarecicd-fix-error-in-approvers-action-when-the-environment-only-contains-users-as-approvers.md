---
title: Fixed Error in approvers action when the environment only contains users as approvers
categories:
  - Software CICD
date:
  created: 2025-09-18
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

We've resolved a problem that was occurring in the cloning of origin environments
to the deployment environments (defined in the .gluon cd folder). If the origin
environment only contained user approvers, the deploy workflow failed.

Also, the workflow was removing user approvers from the origin environments.

**Technical Changes:**

- The action and the workflow responsible for the maintenance of approvers now
handle user approvers. Not removing them from the origin environment but
not adding them to the new environment.

**Problem Impact:**

- Error in deployment execution

**Benefits of the Fix:**

- **Possibility of user approvers**: Now the workflow can handle repositories
with user approvers in the environments
