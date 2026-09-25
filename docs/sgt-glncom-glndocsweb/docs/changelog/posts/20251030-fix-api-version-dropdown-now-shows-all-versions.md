---
title: API version dropdown now shows all versions
categories:
  - APIs
date:
  created: 2025-10-30
tags:
  - Fix
---

![Fix](../assets/images/fix-yammer.png)

### What's Fixed?

Fixed a pagination issue in the API catalog's version dropdown that was limiting the display to only the first 10 versions.
The dropdown now correctly shows all available versions for each API, providing users with complete access to the full version history.

### Problem Description

The API catalog in the Gluon portal contained a bug in the version selection dropdown component.
Due to an incorrect pagination implementation, the dropdown was only displaying the first 10 versions of each API, even when more versions were available.

This limitation prevented users from accessing older or newer versions beyond the initial page,
impacting their ability to work with specific API versions that weren't included in the first 10 results.
The issue has been resolved by fixing the pagination logic to ensure all available versions are properly loaded and displayed in the dropdown menu.
