---
title: Fixed Problem with Push images with approvers in PRO
categories:
  - Software CICD
date:
  created: 2025-09-18
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

We've resolved a problem that was occurring in the push images of GFW release workflows.
When the GFW release workflow was executed, the build was performed from main, now it is performed from the github.sha.

**Technical Changes:**

- Changes in the docker, python, maven and npm release workflows to use github.sha instead of git-ref
- Also changes in the docker and python release workflows to generate tag only after the publish

**Problem Impact:**

- A new image is created from main and not from the commit that the user desires

**Benefits of the Fix:**

- **Publishing of correct image versions**: The correct image versions will be published when approved
- **Generation of tag after publish**: Assurance that the release tag will be created only after the
successful publishing of the image
