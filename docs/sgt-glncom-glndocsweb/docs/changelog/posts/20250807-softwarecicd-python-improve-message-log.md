---
title: Show a message in log when not exits version in setup.py or version.py
categories:
  - Software CICD
date:
  created: 2025-08-07
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

Currently, if the user doesn't specify the version in the setup.py or version.py files, a user-traceable error is not displayed.

### Why Is This Important?

The user must know what caused the error in order to correct it.

### How to Use This Feature?

When the user does not specify the version, the following message is displayed: Error: Failed to retrieve the current version, please check your versioning file
