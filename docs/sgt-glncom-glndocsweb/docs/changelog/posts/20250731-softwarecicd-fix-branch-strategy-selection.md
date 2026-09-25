---
title: Selecting the Right Branch Strategy When Running the Update Workflow in a Component
categories:
  - Software CICD
date:
  created: 2025-07-31
tags:
  - Fix
---

![Improvement](../assets/images/fix-blog.png)

### What's Changing?

We've fixed an issue in the component update workflow where the branch strategy
was not always correctly identified, causing some workflows to be lost. This
affected components that had previously undergone a template migration. With
this update, the branch strategy is now reliably determined, ensuring all
workflows are retained during updates.

### Why Is This Important?

The update process for a component also refreshes its workflows, which depend on
the correct branch strategy. Previously, after a template migration, branch
strategy information could be lost, leading to incomplete workflow updates. Now,
the branch strategy is determined directly from the repository's branch
structure, making the process independent of external systems and ensuring
workflows are updated as expected.

### How to Use This Feature?

No action is needed from regular users.
