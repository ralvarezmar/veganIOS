---
title: Fixed GITHUB_TOKEN permissions to write repository variables
categories:
  - Software CICD
date:
  created: 2025-10-16
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

We've resolved a critical issue in NPM (GFW) workflows where the integration workflow was failing when attempting to automatically launch the CD workflow.
The failure occurred due to insufficient permissions for the default `GITHUB_TOKEN` to write repository variables.

**Technical Changes:**

- Modified the `cd-workflow-initialization` job to conditionally use organization GitHub App tokens
  for repository variable operations
- The `get-project-token` step now only executes when
  `needs.container-build-and-push.outputs.publish-artifact == 'true'`
- Implemented dynamic token management that uses the project token for variable creation
  and restores the original `GITHUB_TOKEN` for workflow execution
- Maintained workflow compatibility with all existing functionality preserved

### Why Is This Important?

This fix resolves **critical production issues** that were causing deployment failures
for AFE SPA components and other templates configured with artifact publishing.

**Problem Impact:**

- AFE SPA components and templates with `"publish": "image|artifact"` configuration
  were experiencing workflow failures
- The default `GITHUB_TOKEN` lacks necessary permissions to create repository variables,
  even with "write-all" permissions enabled
- Failed workflows prevented automatic CD workflow execution and artifact version tracking

**Benefits of the Fix:**

- **AFE SPA components** and other artifact-publishing templates now work correctly
- **Enhanced security**: Uses organization GitHub App tokens only when needed
  for elevated permissions
- **Improved reliability**: CD workflows launch successfully without permission errors
- **Maintained compatibility**: Backward compatibility preserved for components
  that don't publish artifacts

-------------------------------------------------------------------------------------------------------
