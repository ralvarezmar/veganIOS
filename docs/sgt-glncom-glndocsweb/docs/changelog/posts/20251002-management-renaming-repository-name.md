---
title: Repository name customization for components in Gluon
categories:
    - APIs
    - Events
    - Management

date:
    created: 2025-10-02
tags:
    - Feature
---

![Feature](../assets/images/new-feature-blog.png)

### What's Changing?

Gluon now allows application teams to set or update the name of their GitHub source code repositories. When creating or importing a component, users can specify a custom repository name. This new capability affects both the creation and importation of
application components as well as the creation of API and event subscriptions and deployments.

Repository names must be unique within your GitHub organization and follow GitHub's naming rules: up to 100 characters, starting with the company acronym and the `application alias` in the first 12 characters.

For detailed information about repository name management, including naming conventions and best practices, please refer to:

- [Component Creation And Repository Name Guidelines](https://gluon.gs.corp/community/docs/latest/application/component-management/create-component/).
  - [API Deployment 2.0 Component](https://gluon.gs.corp/community/docs/latest/components/software/api/apideployment/apis/#create-component)
  - [API Subscription Component](https://gluon.gs.corp/community/docs/latest/components/software/api/apisubscription/#create-component)
  - [Key Set Component](https://gluon.gs.corp/community/docs/latest/components/software/api/keyset/#create-component)
  - [Event deployment Component](https://gluon.dev.corp/community/docs/latest/components/software/events/deployment/)
  - [Event subscription Component](https://gluon.dev.corp/community/docs/latest/components/software/events/subscription/)

### Why Is This Important?

This enhancement simplifies component management in Gluon by letting teams define repository names that match their organizational standards and project requirements. It reduces onboarding friction for new users and supports
clearer, more consistent repository structures.

The ability to update repository names also accommodates evolving project needs without disrupting existing workflows. Integrations with tools such as Sonar and Fortify remain unaffected, as they continue to rely on the
component's shortname for configuration.
