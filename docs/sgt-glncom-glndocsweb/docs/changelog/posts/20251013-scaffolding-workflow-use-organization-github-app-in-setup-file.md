---
title: Enhanced Scaffolding Workflow with Organization GitHub App Support
categories:
  - Software CICD
date:
  created: 2025-10-13
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

We've created a new GitHub Action that handles organization-specific GitHub App token management for scaffolding workflows.

The new action [`sgt-glna360-get-org-gh-app-token-action`](https://github.com/santander-group-shared-assets/sgt-glna360-get-org-gh-app-token-action) automatically:

- Reads organization GitHub App configuration from `definition.yml` files
- Dynamically generates credential names based on configured prefixes
- Provides organization-specific tokens to setup.sh scripts when available
- Continues scaffolding with default configuration if organization-specific credentials are unavailable

**Technical Changes:**

- **New dedicated action**: Created `sgt-glna360-get-org-gh-app-token-action` to centralize organization token management
- **Dynamic credential prefix reading**: The action reads `alias_github_app` from `definition.yml` to determine credential prefixes
- **Automatic credential resolution**: Constructs variable and secret names as `${PREFIX}_APPLICATION_ID` and `${PREFIX}_APPLICATION_PRIVATE_KEY`
- **Resilient error handling**: Never fails the workflow - provides warnings and continues with default configuration
- **Enhanced setup.sh integration**: Organization tokens are available as environment variables for template customization

### Why Is This Important?

Previously, all scaffolding workflows used the same default GitHub App credentials, which created limitations:

- Templates couldn't access organization-specific resources during setup
- Setup scripts had no way to differentiate between organizations
- No ability to clone organization-specific configurations or shared resources
- Limited template flexibility for organization-specific customizations

This improvement provides **immediate value** by:

- **Enabling organization-specific template behavior**: Setup scripts can now access organization resources and apply custom configurations
- **Maintaining backward compatibility**: Existing templates continue working without changes
- **Improving template flexibility**: Template authors can create more sophisticated setup processes
- **Enhancing security isolation**: Each organization can use its own GitHub App for better access control

The enhancement maintains full backward compatibility while opening new possibilities for template customization and organization-specific setup processes.

-------------------------------------------------------------------------------------------------------
