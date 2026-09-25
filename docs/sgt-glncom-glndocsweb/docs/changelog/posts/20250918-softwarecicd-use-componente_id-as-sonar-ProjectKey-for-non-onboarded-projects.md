---
title: Use COMPONENT_ID as Sonar ProjectKey for non-onboarded projects
categories:
  - Software CICD
date:
  created: 2025-09-18
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

For non-onboarded projects, Component Management cannot determine the Sonar ProjectKey, therefore the default value should be set to the COMPONENT_ID.

**Technical Changes:**

- Changed the Sonar Project Key that was retrieved from properties.env to use the custom property "component_id"

**Problem Impact:**

- Components that have not been onboarded through GLUON cannot pass quality controls

**Benefits of the Fix:**

- **Functional improvement**: Components that have not been onboarded through GLUON can now pass quality controls
