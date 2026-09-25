---
title: In Reuse Images and Third Parties only release versions are allowed for original images
categories:
  - Software CICD
date:
  created: 2025-10-29
tags:
  - Fix
---

![Fix](../assets/images/fix-yammer.png)

### What's Fixed?

A bug in **Image Reuse and Third Party 2.0 workflows** was allowing **non-release versions** in origin images, even though the documentation requires that **only release versions (x.x.x)** be permitted.

The validation now correctly enforces this rule, ensuring that only release images are accepted in deployments.

### Problem Description

Workflows were mistakenly accepting image versions with suffixes such as `1.0.12-SNAPSHOT-d0fcf20`, because validation only checked the **VERSION file** (used for tagging) instead of the actual Harbor image.

### Migration or Upgrade Notes

- Update any deployments using **non-release image versions** to the proper `x.x.x` format.
- Review **Image Reuse and Third Party configurations** to ensure all `ORIGIN_REUSED_IMAGE_VERSION` values follow Semantic Versioning without suffixes.
- Adjust workflows that may have deployed non-release versions.

For detailed instructions on Image Reuse 2.0 prerequisites, please refer to our [Image Reuse documentation](https://gluon.gs.corp/community/docs/latest/components/configuration/kubernetes/image-reuse/#prerequisites).

### Additional Information

This fix ensures compliance with **Image Reuse and Third Party 2.0 prerequisites**, preventing non-release images from being deployed and maintaining consistency with the framework’s design principles.
