---
title: Fix secret cloning when creating new {environment-type}-{environment-name} deploy environment
categories:
  - Software CICD
date:
  created: 2025-07-31
tags:
  - Fix
---

![Improvement](../assets/images/fix-blog.png)

We're excited to announce an update that **fixes secret cloning** when creating
new deployment environments using the `{environment-type}-{environment-name}`
naming convention in Gluon.

### What's Changing?

Secret copying between environments is now more robust and reliable. This means
sensitive information, like OpenSSH private keys, will be handled correctly
every time.

### Why Is This Important?

Some secrets—especially OpenSSH private keys—must end with a carriage return.
When added through GitHub's interface, this is managed automatically.
Previously, when cloning secrets for new environments, the final line break
could be lost, causing issues with authentication and deployments.

### How to Use This Feature?

For most users, no action is required. The deployment pipelines handle
environment creation and secret copying automatically. However, please check the
following situations:

- **If your environment was created before this fix** and the secret copied from
  the source environment lost its final line break, update the secret in the new
  environment `{environment-type}-{environment-name}`.
- **If you can't update the secret manually** (for example, you don't have
  access to the secret), you can delete the new environment and let the
  deployment workflow recreate it with the correct secret.

!!!Note
    Environments are only created by copying an existing environment if the new
    environment does not already exist. If the new environment exists, it will
    not be updated with previous configurations.
