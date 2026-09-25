---
title: Import existing client-ids from API Managers to subscribe to APIs in Gluon
categories:
  - APIs
date:
  created: 2025-09-18
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's New?

Gluon now makes it easier to manage your API subscriptions by letting you import existing client-ids from your API Manager.

**Key Set Component Improvements:**

- You can now import your existing client-ids from your API Manager, not just create new ones.
- When creating a Key Set, simply enter the client-id you want to use—right from the Gluon portal. [How to create a Key Set](../../components/software/api/framework/marketplace/key-set.md)
- By default, the client-id you specify will be used for all environments. If your application has different client-id values for each environment, you can also configure them. [How to configure your existing client-ids in your API Subscription component](../../components/software/api/apisubscription.md/#configuration-files)

**Smarter API Subscription Structure:**

- Each environment can have its own configuration file.
- Manage client-ids directly within the subscription component, including separate client-ids for each environment if needed.

### Why is this important?

With these enhancements, you get:

- **Easy import of existing applications:** Bring your client-ids from API Manager straight into Gluon.
- **Simple client-id setup:** Enter the client-id you want to use when creating Key Sets. No extra steps.
- **Flexible environment configuration:** Use one client-id for all environments, or set up different ones for preproduction and production as needed.
- **Full support for environment-specific credentials:** Perfect for applications that require unique client-ids in each environment.

Enjoy a smoother, more flexible API subscription experience
