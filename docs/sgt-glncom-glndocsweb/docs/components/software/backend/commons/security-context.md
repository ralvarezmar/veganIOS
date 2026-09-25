# Security Context Configuration in Kubernetes Deployments

Kubernetes provides a **Security Context** to define privilege and access control settings for Pods and containers. Proper configuration of Security Context enhances the security posture of your workloads by restricting permissions and capabilities.

## Security Context Overview

A Security Context in Kubernetes defines privilege and access control settings that govern how Pods and containers operate within the cluster.
It serves as a critical security boundary that helps implement the principle of least privilege by controlling what actions containers can perform and what resources they can access.

Security Context configurations enable you to:

- **Control User and Group Identity**: Specify which user (UID) and group (GID) the container processes run as, preventing containers from running as root
- **Manage File System Permissions**: Set ownership and access permissions for mounted volumes and file systems
- **Restrict Privilege Escalation**: Prevent processes from gaining additional privileges beyond what they were initially granted
- **Control Linux Capabilities**: Add or remove specific Linux capabilities to fine-tune what system operations containers can perform
- **Enforce Security Profiles**: Apply security policies like SELinux labels, AppArmor profiles, or seccomp profiles
- **Manage Process Namespace**: Control how containers interact with the host system's process namespace

These security settings can be configured at two hierarchical levels:

- **Pod Level**: Security settings that apply to all containers within the Pod, establishing baseline security policies
- **Container Level**: Container-specific security settings that override Pod-level configurations, allowing for fine-grained control per container

The container-level settings take precedence over pod-level settings when both are specified, providing flexibility to customize security requirements for individual containers while maintaining consistent defaults across the Pod.

## Pod-Level Security Context

The Pod-level Security Context is defined under the `spec.securityContext` field in the Pod specification and establishes default security settings that apply to all containers within the Pod.
This provides a consistent security baseline while allowing individual containers to override specific settings when needed.

Pod-level security contexts are particularly useful for:

- **Establishing Security Baselines**: Setting common security policies that all containers in the Pod should follow
- **Managing Shared Resources**: Controlling access to volumes and file systems that are shared across containers
- **Simplifying Configuration**: Avoiding repetitive security configurations across multiple containers in the same Pod
- **Enforcing Organizational Policies**: Implementing company-wide security standards at the Pod level

**Example:**

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: secure-pod
spec:
    securityContext:
        runAsUser: 1000
        runAsGroup: 3000
        fsGroup: 2000
        runAsNonRoot: true
        seccompProfile:
            type: RuntimeDefault
        supplementalGroups: [4000, 5000]
    containers:
        - name: app
            image: nginx
```

**Key Fields:**

- `runAsUser`: The UID (User ID) that all container processes will run as. Must be a non-zero value to ensure non-root execution
- `runAsGroup`: The primary GID (Group ID) for all container processes, determining group ownership of files created by the containers
- `fsGroup`: The GID applied to all mounted volumes, ensuring proper file system permissions for shared storage
- `runAsNonRoot`: Boolean flag that enforces containers to run as non-root users, providing an additional security check
- `seccompProfile`: Applies a seccomp (secure computing mode) profile to restrict system calls available to containers
- `supplementalGroups`: Additional groups that container processes will be part of, useful for accessing shared resources
- `seLinuxOptions`: SELinux context settings for enhanced mandatory access control (Linux only)
- `windowsOptions`: Windows-specific security settings for Windows containers

## Container-Level Security Context

The Container-level Security Context is defined under each container's `securityContext` field and provides granular control over individual container security settings.
These settings override the Pod-level Security Context for the specific container, enabling fine-tuned security configurations based on each container's unique requirements.

Container-level security contexts are essential for:

- **Specialized Security Requirements**: Different containers may need different privilege levels or capabilities
- **Defense in Depth**: Adding additional security layers beyond Pod-level controls
- **Legacy Application Support**: Accommodating containers that require specific security configurations
- **Microservice Architecture**: Implementing security policies tailored to each service's function and risk profile
- **Third-party Container Integration**: Applying appropriate security constraints to containers from external sources

**Example:**

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: secure-pod
spec:
    containers:
        - name: app
            image: nginx
            securityContext:
                runAsUser: 2000
                runAsGroup: 2000
                runAsNonRoot: true
                allowPrivilegeEscalation: false
                readOnlyRootFilesystem: true
                capabilities:
                    drop:
                        - ALL
                    add:
                        - NET_BIND_SERVICE
                seccompProfile:
                    type: RuntimeDefault
```

**Key Fields:**

- `runAsUser`: Overrides the Pod-level `runAsUser` for this specific container, allowing different user contexts per container
- `runAsGroup`: Sets the primary group ID for this container's processes, overriding Pod-level settings
- `runAsNonRoot`: Container-specific enforcement of non-root execution, providing additional validation
- `allowPrivilegeEscalation`: Critical security control that prevents processes from gaining more privileges than their parent process
- `readOnlyRootFilesystem`: Mounts the container's root filesystem as read-only, preventing runtime modifications and improving security
- `capabilities`: Fine-grained control over Linux capabilities:
    - `drop`: Removes specific capabilities (recommended to drop `ALL` by default)
    - `add`: Grants only the minimum required capabilities for the container's function
- `seccompProfile`: Container-specific seccomp profile to restrict available system calls
- `seLinuxOptions`: SELinux context for mandatory access control (Linux environments)
- `privileged`: Boolean flag that grants the container nearly all host capabilities (use with extreme caution)
- `procMount`: Controls how `/proc` is mounted in the container (Default or Unmasked)

## Security Context configuration in Gluon components

All Gluon global components that are deployed in Kubernetes, such as microservices, SPAs, and microfrontends, can have their security context configured in `values.yaml` files in the deployment configuration.
Currently, when creating new components, the default configuration for Security Context at both levels, pod and container, is included in `values.yaml`. It could be adjusted by developers in order to fulfill the security requirements of their applications.

But old components, created prior to July 2025, must be manually configured in order to fulfill the security requirements.
This can be done enabling the `podSecurityContext` and/or `containerSecurityContext` nodes in `values.yaml` files.

For that you should look for the nodes named `podSecurityContext` and `containerSecurityContext` in the `values.yaml` file of the component you want to configure. Then you can enable them and set the desired values for the security context.

Following is the Security Context configuration in the Gluon component's `values.yaml` file that you need to include to fulfill security requirements:

**Pod-level Security Context configuration:**

``` yaml
podSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 20000 # Remember to align it with your Dockerfile
  seccompProfile:
    type: RuntimeDefault
```

**Container-level Security Context configuration:**

``` yaml
containerSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 20000 # Remember to align it with your Dockerfile
  seccompProfile:
    type: RuntimeDefault
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

???+ tip "Security Best Practices"

    When configuring Security Context for Gluon components, follow these security best practices:
    
    - **Always set `runAsNonRoot: true`** to prevent containers from running as root
    - **Use `readOnlyRootFilesystem: true`** when possible to prevent runtime file system modifications
    - **Drop all capabilities with `drop: [ALL]`** and only add specific ones that are absolutely necessary
    - **Set `allowPrivilegeEscalation: false`** to prevent privilege escalation attacks
    - **Use `seccompProfile.type: RuntimeDefault`** to apply the default seccomp profile for system call filtering
    - **Choose user IDs ≥ 10000** to avoid conflicts with system users and comply with security requirements

    You can check the Security Requirements in the OpenShift Hardening guide by CISO team in the following Sharepoint site: CyberConnection --> Compliance --> Hardening Guides --> [CS-HG-002_OpenShift_HardeningGuide.pdf](https://santandernet.sharepoint.com/:b:/r/sites/Cyber-Connection/Hardering%20Guides/Hardening%20Guides/CS-HG-002_OpenShift_HardeningGuide.pdf?csf=1&web=1&e=FWeSF2).

    If you can't access the document, please contact your local CISO team.

!!!Note "runAsUser Property Requirements"

      **Security Requirements:**
      The default security requirement specifies that the `runAsUser` property value must be greater than or equal to 10000. This ensures that applications run as non-root users, significantly enhancing security by minimizing privileges and reducing the attack surface.

      **User ID Alignment:**
      The `runAsUser` value must be aligned with the user ID configured in the container image, which is typically set in the Dockerfile using the `USER` directive. Always verify the Dockerfile of your container image to ensure compatibility between the Security Context `runAsUser` value and the image's user configuration.

## Common Security Patterns and Troubleshooting

### Recommended Security Configuration Pattern

For most Gluon applications, the following pattern provides a strong security foundation:

```yaml
# Pod-level baseline security
podSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 20000 # Remember to align it with your Dockerfile
  seccompProfile:
    type: RuntimeDefault

# Container-level enhanced security
containerSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 20000 # Remember to align it with your Dockerfile
  seccompProfile:
    type: RuntimeDefault
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

### Common Issues and Solutions

#### Permission denied when accessing files

- **Solution**: Verify that `fsGroup` matches the group ownership of mounted volumes
- **Check**: Ensure the container image supports the specified user ID

#### Application fails to bind to privileged ports (< 1024)

- **Solution**: Add `NET_BIND_SERVICE` capability or use non-privileged ports (> 1024)
- **Alternative**: Use a service mesh or reverse proxy to handle privileged port binding

#### Container cannot write to temporary directories

- **Solution**: Mount writable `tmpfs` volumes or `emptyDir` volumes for temporary files when using `readOnlyRootFilesystem: true`

#### Legacy applications requiring root access

- **Solution**: Refactor the application to run as non-root, or use init containers with elevated privileges for setup tasks only

## References

- [Kubernetes Security Context Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Linux Capabilities Overview](https://man7.org/linux/man-pages/man7/capabilities.7.html)
- [Seccomp Security Profiles](https://kubernetes.io/docs/tutorials/security/seccomp/)
