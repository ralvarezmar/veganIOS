# Security Context

Security contexts in Kubernetes are a set of configuration options that define privilege and access control settings for Pods and containers.
They allow you to specify security-related attributes such as user and group IDs, privilege escalation, and Linux capabilities, helping to enforce security policies at runtime.

At the Pod level, a security context sets default security settings for all containers within the Pod.
This can include specifying that all containers must run as a non-root user, setting a default user ID, or applying a seccomp profile for system call filtering.
These settings help ensure that the Pod as a whole adheres to organizational security standards and reduces the risk of privilege escalation attacks.

At the container level, security contexts provide more granular control, allowing you to override Pod-level defaults for individual containers.
You can restrict privilege escalation, drop unnecessary Linux capabilities, and enforce running as a specific user.
This is particularly useful when different containers within the same Pod have varying security requirements.

By properly configuring security contexts, you can significantly improve the security posture of your Kubernetes workloads, minimize attack surfaces, and comply with best practices for containerized applications.

## Default Security Context Configuration

The default security context configuration in Gluon follows the recommendations provided by the cybersecurity team (Ciber), ensuring an optimal level of protection for frontend components.
These values have been carefully selected to minimize risks and comply with Kubernetes security best practices.

**For New Components**: When you create a new frontend component using Gluon, the security context configuration will be automatically applied. No additional action is required.

**For Existing Components**: If you have existing frontend components, you can manually update their configurations to include the new security context settings by adding the configuration below to your `.gluon/cd/values.yaml` file.

```yaml
podSecurityContext:
  enabled: false

podDefaultSecurityContext:
  enabled: true

containerSecurityContext:
  enabled: false

containerDefaultSecurityContext:
  enabled: true
```

It is essential to keep these default values enabled and avoid modifying them, as disabling or altering them could expose your applications to vulnerabilities and reduce the protection level recommended by Ciber.

Only in exceptional cases, when the project imperatively requires it, should you consider customizing the configuration.
Gluon provides an option to customize the security context in such scenarios, but this is not desirable and should be done with caution and technical justification.
See [next section](#customizing-the-security-context) to do it.

In case that podSecurityContext and podDefaultSecurityContext were enabled at same time, podSecurityContext will prevail.
Same for containerSecurityContext and containerDefaultSecurityContext, containerSecurityContext will prevail.

### podDefaultSecurityContext

This configuration will setup the POD security context as follows:

```yaml
  runAsNonRoot: true
  runAsUser: 999
  seccompProfile:
    type: RuntimeDefault
```

### containerDefaultSecurityContext

This configuration will setup the container security context as follows:

```yaml
  runAsNonRoot: true
  runAsUser: 999
  seccompProfile:
    type: RuntimeDefault
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

## Customizing the Security Context

In Gluon we offer two different properties on values.yaml that enable you to customize the security context of for both scopes (POD & Container).
In case that podSecurityContext and podDefaultSecurityContext were enabled at same time, podSecurityContext will prevail.
Same for containerSecurityContext and containerDefaultSecurityContext, containerSecurityContext will prevail.

### podSecurityContext

```yaml
## Setup custom pods security context for web. In case podSecurityContext and podDefaultSecurityContext were enabled
## at same time, podSecurityContext will prevail.
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
## @param podSecurityContext.enabled Enable security context for the pods
## @param podSecurityContext.runAsNonRoot Ensures that all containers in the Pod run as a non-root user.
## @param podSecurityContext.runAsUser Sets the user ID (UID) that all containers in the Pod should run as.
## @param podSecurityContext.seccompProfile Sets the seccomp profile for all containers in the Pod.
## e.g:
##   podSecurityContext:
##     enabled: true
##     runAsNonRoot: true
##     runAsUser: 999
##     seccompProfile:
##       type: "RuntimeDefault"
##
podSecurityContext:
  enabled: false
```

### containerSecurityContext

```yaml
## Setup custom container security context for web. In case containerSecurityContext and containerDefaultSecurityContext were enabled
## at same time, containerSecurityContext will prevail
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
## @param containerSecurityContext.enabled Enable web containers' Security Context
## @param containerSecurityContext.runAsNonRoot Specifies whether the container must run as a non-root user.
## @param containerSecurityContext.runAsUser Specifies that for any Containers in the Pod, all processes run with the configured user.
## @param containerSecurityContext.seccompProfile Specifies the seccomp (secure computing mode) profile to be used for the container.
## @param containerSecurityContext.allowPrivilegeEscalation Controls whether processes inside the container can gain more privileges than their parent process.
## @param containerSecurityContext.capabilities Allows you to add or remove Linux capabilities for the container process.
## e.g:
##   containerSecurityContext:
##.    enabled: true
##     runAsNonRoot: true
##     runAsUser: 999
##     seccompProfile:
##       type: "RuntimeDefault"
##     allowPrivilegeEscalation: false
##     capabilities:
##       drop:
##         - ALL
##
containerSecurityContext:
  enabled: false
```
