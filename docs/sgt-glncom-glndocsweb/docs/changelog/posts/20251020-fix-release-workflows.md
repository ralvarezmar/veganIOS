---
title: Bug fix in fix-release workflows
categories:
  - Web
date:
  created: 2025-10-20
tags:
  - Fix
---

![Bug Fix](../assets/images/fix-yammer.png)

### What's Fixed?

We have resolved a bug in **fix-release workflows** that was incorrectly treating frontend applications as libraries instead of applications.

**Issue Reference:** INC059252557/PRB000146523

### Migration or Upgrade Notes

If you have experienced this issue with your frontend application components, you can resolve it by updating your components using the update workflow.

For detailed instructions on how to update your components, please refer to our [Component Update documentation](../../application/component-management/update-component.md).

### Additional Information

This fix applies specifically to fix-release workflows for frontend applications and does not affect regular release or deployment workflows, which were already handling these components correctly.
