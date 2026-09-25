---
title: Creation of Rulesets for develop and development branches.

categories:
  - SDLC Tools
  - Security
  - Software CICD

date:
  created: 2025-08-27
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

Developers and technical leads on application teams will now be allowed to
self-approve pull requests (using a bypass) when targeting the develop and
development branches. These branches are only intended for generating
snapshots and cannot be used to deploy code to Production.

While this bypass is allowed, it should only be used in exceptional cases—
specifically, when no reviewers are available and there is an urgent need to
test changes in a development environment. Code reviews should still be
performed on these pull requests as a best practice.

Approval requirements for pull requests targeting the main, master, release*,
or fix* branches remain unchanged: at least one approval is still mandatory
before merging. This is because these branches can lead to the creation of
closed versions of a component that may be deployed to Production.

### Why Is This Important?

Allowing self-approval on develop and development branches provides flexibility
for teams to quickly test and iterate in development environments, especially
when urgent changes are needed and reviewers are unavailable. This helps
maintain development velocity without compromising production stability.

At the same time, maintaining mandatory approvals for pull requests to main,
master, release*, and fix* branches ensures that any code intended for
production deployment receives the appropriate review and oversight,
safeguarding the quality and security of released components.
