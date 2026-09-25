---
title: Gravity Partenon Performance improvement (Release registry)
categories:
  - Gravity
date:
  created: 2025-11-05
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's New?

Gluon Gravity now bases all its dependencies in github.com organizations so there are no github.alm involved since all of them have been migrated from old ALM Multicloud to Gluon.

### Why is this important?

With this migration, all scripts invoked from Gluon Gravity workflows are not going anymore to grab contents outside of github.com. In this way there are two basic improvements: better performance on time execution basis and also fewer possibilities
 of system communications potential issues while promoting software.
