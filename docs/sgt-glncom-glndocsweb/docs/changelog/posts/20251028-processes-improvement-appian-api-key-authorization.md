---
title: Add API Key Authorization Support for Appian Deployments
categories:
  - Process
date:
  created: 2025-10-28
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

Enhanced Appian deployment documentation to support API key authorization alongside the traditional username/password authentication method. This provides developers with flexible authentication options based on their environment requirements.

#### Key Updates

- **API Key Authorization**: Added support for modern API key authentication using Appian's REST API
- **Conditional Prerequisites**: Updated documentation with requirements based on chosen authorization method
- **OAM Configuration**: Added `authorizationType` and `apiKey` parameters to Open Application Model
- **Secret Management**: Enhanced guidance for configuring secrets per authorization type

### Why Is This Important?

1. **Enhanced Security**: Modern API key authentication provides better security practices
2. **Flexibility**: Choose between traditional username/password or API key methods
3. **Future-Ready**: Supports Appian instances with REST API capabilities
4. **Clear Guidance**: Simplified configuration instructions for both methods

### What You Need to Know

#### Authorization Types

| Type | Secrets Required | Method |
|------|------------------|--------|
| `user` (default) | `APPIAN_USER`, `APPIAN_PASSWORD` | Java-based ADM Import Client |
| `apiKey` | `APPIAN_KEY` | Appian REST API |

#### Basic Configuration

**User Authorization (Default):**

```yaml
properties:
  type: APPIAN
  username: APPIAN_USER
  password: APPIAN_PASSWORD
  authorizationType: user  # optional, default
```

**API Key Authorization:**

```yaml
properties:
  type: APPIAN
  apiKey: APPIAN_KEY
  authorizationType: apiKey
```

### Impact

- ✅ **Backward Compatible**: Existing configurations continue to work unchanged
- ✅ **Enhanced Documentation**: Clear guidance for both authentication methods
- ✅ **Improved Security**: Support for modern API key authentication

### Documentation Updates

- **[Appian Processes Component](../../components/software/processes/appian-processes-component.md)**: Enhanced prerequisites and secret configuration guidance
- **[OAM Params - Appian Section](../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md#appian)**: Added new authorization parameters and examples
