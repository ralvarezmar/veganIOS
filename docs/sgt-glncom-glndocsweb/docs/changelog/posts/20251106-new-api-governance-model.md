---
title: New API Governance Model
categories:
  - APIs
date:
  created: 2025-11-06
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

The new governance model goal is to adapt the current API Governance process to an organization based on Global Business and Domains.
From now on, There is no longer a single Global Governance team; instead, there are dedicated Governance teams for each global business.

### What's changing?

- New API Governance model is implemented in Gluon.

- [New fields](../../components/software/api/framework/lifecycle/apidefinition.md#proposal-for-a-new-api) to classify certified APIs (api_type, global_business and domain).

- API definition components are being generated every time a new definition is created.

- API checks (dictionary and spectral) can be [skipped by domain or individually by API](../../components/software/api/framework/lifecycle/apidefinition.md#skip-dictionary-of-terms-andor-spectral).

- API definitions [can be seen in the marketplace](../../components/software/api/framework/lifecycle/apidefinition.md#whether-a-new-or-modified-api-is-needed) and they can be filtered by any of the new fields.

### Why is this important?

These changes introduce a more structured and flexible approach to API management within Gluon:

- **New Domain Governance Model**: The new governance model allows that global businesses and domains are now responsible by their API definitions, managing their entire lifecycle.
It helps ensure that APIs meet business requirements and technical standards before being made available to consumers.

- **Enhanced API Classification**: The new fields for API type, global business, and domain enable better organization and discoverability of APIs across the platform, making it easier for teams to find and reuse existing APIs.

- **Automated Component Generation**: Automatic generation of API definition components streamlines the development process, reducing manual work and ensuring consistency across all API definitions.

- **Flexible Quality Controls**: The ability to skip API checks at the domain level or for individual APIs provides teams with the flexibility to handle special cases while maintaining overall quality standards.
