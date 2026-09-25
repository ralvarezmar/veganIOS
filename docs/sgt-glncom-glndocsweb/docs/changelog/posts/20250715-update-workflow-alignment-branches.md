---
title: Improved the Update-Workflow for Branch Consistency
categories:
  - Software CICD
date:
  created: 2025-07-15
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

We are pleased to announce an improvement to the **update-component-workflow** Workflow in Gluon, designed to enhance the alignment between the `development` and `main` branches after workflow updates.

### What's Changing?

With this improvement, the **update-component-workflow** Workflow ensures that changes made to `.github/workflows` on both branches, `main` and `development`, are correctly identified by GitHub, with no differences between them.

### Why Is This Important?

This enhancement ensures consistent alignment between development and main, eliminating confusion when integrating branches. Users can confidently proceed without encountering unexpected changes in the `.github/workflows` folder.

### How to Use This Feature?

The improvement is automatically applied to the **update-component-workflow** Workflow. Users can continue running it on demand to update workflows, ensuring both branches remain aligned without discrepancies over changes in `.github/workflows`.

!!!Note
    For more details about **update-component-workflow** Workflow, please refer to the documentation available in the [Updating your Component](../../application/component-management/update-component.md) section.
