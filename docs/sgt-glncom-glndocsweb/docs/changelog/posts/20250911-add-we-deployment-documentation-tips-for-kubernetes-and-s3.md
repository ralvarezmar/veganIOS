---
title: Add web deployment documentation tips for kubernetes and s3
categories:
  - Web
date:
  created: 2025-09-11
tags:
  - Feature
---
 
![Feature](../assets/images/new-feature-blog.png)

### What's Changing?

We have added [new documentation](../../components/software/front/web/core/best-practices/deployment-tips.md) outlining best practices and tips for deploying front-end components to both S3 (as artifacts) and Kubernetes (as immutable images).

The new guide explains how to select the deployment target in the OAM configuration, the behavior of default CI/CD workflows, and how to optimize your pipeline by skipping unnecessary artifact uploads when deploying only to Kubernetes.

### Why Is This Important?

This update provides clear guidance to help teams choose the most suitable deployment strategy for their needs, ensuring efficient and reliable delivery of front-end components.

By understanding the differences between S3 and Kubernetes deployments, and how to configure workflows accordingly, teams can streamline their processes, reduce build times, and avoid unnecessary steps in their CI/CD pipelines.
