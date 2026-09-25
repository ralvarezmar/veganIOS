---
title: Enhanced Update Component Workflow with Organization GitHub App Support
categories:
  - Software CICD
date:
  created: 2025-10-29
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

We have extended organization‑aware GitHub App token resolution to the component update workflow (`update-component-workflows.yml`).
Previously this capability existed only during scaffolding; now updates to a Component Template version can automatically obtain
organization‑specific credentials.

The action [`sgt-glna360-get-org-gh-app-token-action`](https://github.com/santander-group-shared-assets/sgt-glna360-get-org-gh-app-token-action) now, when a template `definition.yml` is present:

- Reads organization GitHub App configuration (`alias_github_app`)
- Derives credential prefixes and resolves secrets/vars
- Exposes organization tokens for the update script (`update.sh`) or other steps
- Falls back silently to default credentials if none are defined

**Technical Changes:**

- Conditional step added after downloading `definition.yml`
- Token action only runs when the file exists
- Prefix‑based secret name convention: `${PREFIX}_APPLICATION_ID` / `${PREFIX}_APPLICATION_PRIVATE_KEY`
- Safe fallback path (no workflow failure on missing org data)
- Tokens available to branch update and script execution logic

### Why Is This Important?

Before this enhancement the update process reused generic credentials, limiting:

- Access to organization‑restricted resources during upgrades
- Custom logic in `update.sh` per organization
- Segregation of privileges across multiple organizations

Now the workflow:

- Enables organization‑specific behavior during version updates
- Preserves backward compatibility (no required changes if `definition.yml` absent)
- Improves security isolation and auditability
- Establishes a foundation for richer per‑organization update strategies

-------------------------------------------------------------------------------------------------------
