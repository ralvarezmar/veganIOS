---
title: Ensure that created protected branches (release/hotfix) have Gluon workflows
categories:
  - Software CICD
date: 
  created: 2025-09-18
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

We've enhanced the `create-release-branch` workflow to ensure that any protected branch (release/hotfix) created from a tag will always contain valid Gluon workflows.
The workflow now verifies whether the `.github` and `.gluon` folders in the tag match those in the default branch. If they don't match or are missing,
the workflow automatically imports them from the default branch and applies them to the new release/hotfix branch.

This improvement addresses scenarios where:

- Brownfield components with pre-Gluon tags are being used
- Tags with missing or outdated workflow files are selected
- Custom or non-standard workflows are present in the tag

### Why Is This Important?

This enhancement guarantees that all protected branches can properly execute their CI/CD pipelines using the latest standard Gluon workflows,
regardless of the tag's origin. It enables teams working with brownfield projects to continue the lifecycle of versions created before their import to Gluon,
reducing friction and manual intervention in the release process.

By automatically aligning workflow files with the default branch standards, we ensure consistency across all release/hotfix branches and eliminate potential failures due to missing or incompatible workflows.

**Before:**

- Release/hotfix branches created from pre-Gluon tags could have missing or outdated workflow files
- Manual intervention was required to update workflow files

**After:**

- All release/hotfix branches automatically contain the latest Gluon workflows
- No manual intervention is needed to align workflow files
