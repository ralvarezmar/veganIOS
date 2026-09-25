---
title: Improved the Security Context Preconfiguration for Gluon Microservices 
categories:
  - Back
date:
  created: 2025-08-04
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

Before, for the Gluon microservices components, a default security context configuration was not being generated.
Now it is.

#### New default security context default configuration

```yaml
podSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 20000
  seccompProfile:
    type: RuntimeDefault

containerSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 20000
  seccompProfile:
    type: RuntimeDefault
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

#### Updated Gluon components

- Arsenal microservice
- Photon microservice
- Darwin Spring Boot microservice
- Darwin NodeJS microservice
- Darwin Python microservice

### Why Is This Important?

Security is a critical aspect of any microservices architecture. By preconfiguring the security context for Gluon
microservices, we ensure that they run with the least privilege necessary, reducing the risk of potential
vulnerabilities and attacks.
This change enhances the overall security posture of applications built with Gluon.

### How to Use This Feature?

To take advantage of this new security context preconfiguration, you have to create a new Gluon microservice and the
new default security context will be applied automatically. If you have existing microservices,
you can manually update their configurations to include the new security context settings.

!!!Note
     For previous components created you can manually configure the Security Context in `.gluon/cd/values.yaml` file. Follow
     the recommendation explained in the [Security Context configuration section](../../components/software/backend/commons/security-context.md).
