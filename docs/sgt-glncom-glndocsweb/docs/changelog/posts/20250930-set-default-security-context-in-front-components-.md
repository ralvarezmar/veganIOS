---
title: Default Security Context Configuration for Frontend Components
categories:
  - Web
date:
  created: 2025-09-30
tags:
  - Feature
---
 
![Feature](../assets/images/new-feature-blog.png)

### What's Changing?

We are excited to announce that **all frontend components now include pre-configured Security Context for pods and containers aligned with the security constraints**.
This new feature ensures that frontend applications run with proper security configurations out of the box, following security best practices and hardening guidelines.

You can take a look closer in [this article](../../components/software/front/web/core/best-practices/kubernetes/security-context.md).

### Why Is This Important?

Security is paramount in modern web applications. By preconfiguring the Security Context for frontend components, we ensure they run with the **least privilege principle**, significantly reducing security risks and potential attack vectors.

**Key Benefits:**

- **🛡️ Enhanced Security Compliance**: Meet internal and external security requirements automatically
- **🔒 Least Privilege Access**: Containers never run as root and operate with minimal privileges
- **📋 Audit Readiness**: Avoid security findings and streamline security audits
- **🎯 Consistency**: Apply standardized security configurations across all frontend components
- **⚙️ Flexibility**: Allow granular adjustments for specific frontend requirements when needed
