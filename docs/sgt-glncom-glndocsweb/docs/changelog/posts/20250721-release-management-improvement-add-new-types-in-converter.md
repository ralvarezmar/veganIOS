---
title: Improvement Release Management Add Support New Types of Component Status Management
categories:
  - Release
date:
  created: 2025-07-21
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png){width=100%}

### What's Changing?

✅ **IMPROVEMENT: Enhanced Component Status Support**  
  We've expanded our component status management capabilities by adding support for two new status types:

  - `ARCHIVED` - For components that have been archived
  - `ARCHIVED_ATTENTION` - For archived components that require attention
  
These new status types have been integrated into our converter API to ensure seamless compatibility with the management API that provides component specifications.

### Why Is This Important?

Complete component lifecycle management requires proper handling of all possible status types. This improvement prevents potential system errors that could occur when processing components with these newly introduced statuses.
By keeping our status enum synchronized with the management API, we ensure consistent behavior across the platform and avoid disruptions in the release management workflow.
