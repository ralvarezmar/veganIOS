---
title: Deploying to Certification Environments from a Feature Branch for NPM Worflows
categories:
  - Software CICD
  - Management
date:
  created: 2025-06-19
tags:
  - Feature
---

![Feature](../assets/images/new-feature-blog.png)

We are excited to announce a new feature in Gluon enabling deployments to certification environments from feature branches, compatible with **NPM** workflows, streamlining testing and validation without requiring integration branch merges.

### What's Changing?

With this new feature, teams can:

- Deploy feature branches to certification environments using the `.gluon/ci/deploy-target.yml` configuration file.
- Validate and test changes in a controlled environment before integration.
- Use wildcards (e.g., `feature/*`) to enable deployments from multiple feature branches.

This functionality is available for both `GitFlow` and `Trunk Based Development` branching strategies.

### Why Is This Important?

This improvement simplifies the deployment process, reduces integration risks, and enhances the efficiency of testing workflows. It empowers teams to ensure the quality of their changes in certification environments before merging.

### How to Use This Feature?

To use this feature, configure the `.gluon/ci/deploy-target.yml` file in your repository with the following structure:

```yaml
ci-checks:
  source-branch: feature/your-feature
  target-branch: development
  environment: cert
```

Once configured, simply open a pull request from your feature branch to an integration branch. If the source and target branches match the configuration, the deployment will automatically occur.

!!!Note
    For detailed instructions on how to configure the `deploy-target.yml` file, see the documentation available for each [Software Front Web Journeys](../../components/software/front/web/index.md), in the **Integration Workflow** subsection.
