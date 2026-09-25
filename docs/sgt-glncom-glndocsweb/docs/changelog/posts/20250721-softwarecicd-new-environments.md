---
title: New deployment environment naming management {environment-type}-{environment-name}
categories:
  - Software CICD
date:
  created: 2025-07-21
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

We are pleased to announce a new internally managed **deployment naming convention with this format {environment-type}-{environment-name}** in Gluon.

### What's Changing?

With this improvement a new deployment environment will be automatically created in GitHub by cloning the already created old-named environment.

So, when a new deployment is triggered and an environment named certification, preproduction or production exist in the component's GitHub repository settings, it will be cloned and the new naming convention will be used.

### Why Is This Important?

With this enhancement, we allow application component deployments through release management to be performed only on new versions of the components.

That is, instead of deploying all components with the application deployment (OAM), the process will search for components already deployed in the environment and only deploy those with a version change.

### How to Use This Feature?

The generation of new environments is automatic.

Therefore, to use this feature, a user does not need to change their current behavior in terms of:

- Environment definition in the OAM
- Secrets upload to Hasicorp Vault
- Execution of the CD workflow

!!!Note
    For more details, please refer to the documentation available in the [Common CD Workflow](../../application/ci-cd/cd/cd-rm/cd-workflow/index.md) section.
