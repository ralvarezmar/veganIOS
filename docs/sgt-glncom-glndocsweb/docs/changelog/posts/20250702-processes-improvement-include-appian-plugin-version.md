---
title: Parameterize the Appian plug-in version
categories:
  - Process
date:
  created: 2025-07-02
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

A change has been made to the Appian pipeline: it is now possible to specify the version of the Appian plugin using the property `APPIAN_ADM_IMPORT_CLIENT_VERSION` found in the `.gluon/ci/properties.env` file.
The available options are `2.5.9` and `2.6.2`. If the property is not set, the pipeline will use version `2.6.2` by default.

### Why Is This Important?

Deployment issues had been identified after upgrading several servers. Allowing the plugin version to be explicitly set helps prevent compatibility problems and ensures smoother deployments across different environments.
