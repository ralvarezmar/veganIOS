---
title: Web Library Component with Nx
categories:
  - Web
date:
  created: 2025-07-03
tags:
  - Feature
---

![Feature](../assets/images/new-feature-blog.png){ width=100%}

We are thrilled to announce that, starting today, **our users can now create and manage Web Libraries using Nx within the GLUON platform**.

This new feature enables teams to build, analyze, and publish reusable libraries with support for scaffolding in **Angular** and **React**, while also allowing the flexibility to use other technologies based on **TypeScript** or **JavaScript**.

### Why is this important?

Web Libraries are essential for sharing components, utilities, and services across multiple applications and teams. By using Nx, you gain access to:

- **Flexible Scaffolding**: Start with Angular or React scaffolding, or customize it to fit other technologies based on TypeScript or JavaScript.
Note that while Angular and React are the default scaffolding options, users can extend or modify the setup for other frameworks or plain TypeScript/JavaScript libraries.
- **Monorepository Management**: Nx provides a scalable and maintainable structure for managing multiple libraries and applications in a single workspace.
- **Enhanced Developer Experience**: Nx offers powerful tools like dependency graph visualization, task orchestration, and caching to speed up development.
- **Seamless CI/CD Integration**: The GLUON platform integrates Nx workflows into its pipelines, ensuring consistency and efficiency in your build, test, and deployment processes.

### How to Use This Feature?

To get started, simply create a new component of type **Web Library** from the Gluon Portal. The platform will scaffold the library structure using Nx, including a playground application for development and testing.

You can then follow our step-by-step guide to build, analyze, and publish your library through the CI/CD process.

For detailed instructions and best practices, please refer to the [Web Library Journey documentation](../../components/software/front/web/core/library/index.md).
