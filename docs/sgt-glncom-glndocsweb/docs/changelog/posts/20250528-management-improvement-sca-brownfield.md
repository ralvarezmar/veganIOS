---
title: Brownfield components 6-month grace period on SCA gate
categories:
  - Software CICD
  - Security
date:
  created: 2025-05-28
tags:
  - Improvement
---

![Feature](../assets/images/improvement-blog.png)

We are glad to announce that to facilitate the migration of components from local engineering platforms to Gluon, we are providing a 6-month grace period for migrated components on Software Composition Analysis (SCA) security gate.

### What's Changing?

When a component is migrated from a local engineering platform to Gluon, it will be marked as **Brownfield** allowing it to pass the Software Composition Analysis (SCA) security
gate checks for a period of **6 months** without making the continuous integration workflow fail due to critical or high security issues.

During this period:

- The Security Gate for third-party library scans (SCA) will allow these components to pass checks, regardless of the severity of detected vulnerabilities.
- This **Brownfield attribute** will automatically deactivate at the end of the grace period or earlier if:
  - A scan detects no critical or high-severity vulnerabilities.

Once the attribute is deactivated, the components will be subject to standard security policies, ensuring compliance with security standards while
minimizing disruptions during the migration process.

### Why Is This Important?

This change allows reducing the migration impact caused by the tools changes.

### How to Use This Feature?

Components which are imported based on repositories already existing in your Gluon Github Organizations will automatically be enabled with this improvement.

!!!Note
    For companies that are migrating their components creating new components in Gluon and after that copying the code from their original source repository to the new one created
    by Gluon, they have enabled and endpoint to switch a Greenfield component to Brownfield, so they are able to benefit from this grace period.
