# Dealing with Vulnerabilities

Backend Java frameworks are widely used to build robust and scalable applications, but they can also be targets for security vulnerabilities.
Understanding how to identify and address these vulnerabilities is essential for maintaining the security and reliability of your software.
This guide provides an overview of the main types of security analysis—SAST, SCA, and container scanning—and offers practical steps to remediate common issues detected during the development lifecycle.

## Security SAST, SCA and Container Analysis

During the CI process, security code analysis tools help identify vulnerabilities in your codebase, dependencies, and container images:

- **SAST (Static Application Security Testing):** Analyzes source code or binaries for security vulnerabilities without executing the program.<br>
  It helps detect issues such as SQL injection, XSS, and insecure coding patterns directly in your application's code.<br>
  Gluon integrates with the Santander Group SAST analysis tool [Fortify SCC](https://www.opentext.com/products/static-application-security-testing) to perform SAST on code.

- **SCA (Software Composition Analysis):** Scans your project's dependencies to identify known vulnerabilities in third-party libraries and frameworks.<br>
  It checks if you are using outdated or vulnerable versions and provides remediation guidance.<br>
  Gluon integrates with the Santander Group SCA analysis tool [Sonatype IQ Server SCA](https://help.sonatype.com/en/sonatype-iq-server.html) to perform SCA on libraries.

- **Container Vulnerability Scanners:** Examine container images for vulnerabilities in operating system packages and base images.<br>
  They ensure that the images used to deploy applications do not contain known security issues.<br>
  Gluon integrates with the Santander Group container analysis tool [Sysdig Platform](https://sysdig.com/products/platform/) to perform container analysis.

### SAST Vulnerabilities

SAST tools identify vulnerabilities that exist directly within the application's source code, such as insecure coding practices, logic errors, or missing input validation.

These issues are specific to the code written by developers and cannot be automatically fixed by updating dependencies or container images.

Resolving SAST-detected vulnerabilities requires direct action from the development team to review, refactor, and secure the affected code.

#### Addressing SAST Vulnerabilities

The following flowchart shows how to address SAST vulnerabilities:

![SAST-Vulnerability](images/vulnerabilities-use-cases.drawio)

### SCA Vulnerabilities

SCA tools identify vulnerabilities in third-party libraries and dependencies used in the application. These vulnerabilities are often due to outdated or insecure versions of libraries.

#### Steps to Remediate SCA Vulnerabilities

To address SCA vulnerabilities, follow these steps:

- Ensure you are using the latest version of the libraries in your project. This can be done by:
  - Checking if you are using the latest version of the framework. See the following release links:
    - [Arsenal Backend Releases](https://github.com/santander-group-shared-assets/gln-back-arsenal-backend-spring/releases)
    - [Arsenal Integration Releases](https://github.com/santander-group-shared-assets/gln-back-arsenal-integration-spring/releases)
    - [Darwin Java Releases](https://github.com/santander-group-shared-assets/gln-back-darwin-java-spring-boot/releases)
    - [Photon Releases](https://github.com/santander-group-shared-assets/gln-back-photon-java-quarkus/releases)
  - If the library was introduced by your project (not by the framework), update it in your `pom.xml` to a version without vulnerabilities.
  - If there are no new versions available, check the SCA analysis results for possible workarounds or patches for the identified vulnerabilities.
  - Refer to [Gluon News](https://engage.cloud.microsoft/main/org/santander.com/groups/eyJfdHlwZSI6Ikdyb3VwIiwiaWQiOiIxMjcwODc0NzY3MzYifQ) for information about the latest vulnerabilities detected in development frameworks and how to fix them.

#### Vulnerabilities Without a Fix

Sometimes, vulnerabilities may not have an available fix. In these cases:

- If the vulnerability is in a library introduced by your project:
  - Consider using an alternative library that is not affected.
  - Analyze the vulnerability; if it does not impact your project, you can request a false positive classification from your local CISO team.
  - If a fix is in progress, you can request a temporary security waiver while waiting for the update, and then update your project accordingly.
- If the vulnerability is in a library introduced by the development framework:
  - The framework team will analyze the vulnerability. If it does not affect projects, they will request a false positive classification from the CISO team, which will be applied to all projects.
  - If a fix is in progress, the framework team will request a temporary security waiver. Once approved, the waiver will be applied to all projects until the fix is available.

#### Addressing SCA Vulnerabilities

The following flowchart shows how to address SCA vulnerabilities:

![SCA-Vulnerability](images/vulnerabilities-use-cases.drawio)

### Container Vulnerabilities

Container vulnerabilities typically arise from outdated or insecure base images used in your containerized applications.
These vulnerabilities are usually related to the operating system packages and libraries included in the base image, not the application code itself.

If your Sysdig scanner detects vulnerabilities in your component image, you will likely need to update your base image version. Follow these steps:

- Locate the lines in your `Dockerfile` starting with `FROM`.
- Check the version of the base image at the end of the line (e.g., `FROM registry.global.ccc.srvb.bo.paas.cloudcenter.corp/produban/javase-17-ubi8:1.2.17-RELEASE`).
- Update the version to the latest available (e.g., `FROM registry.global.ccc.srvb.bo.paas.cloudcenter.corp/produban/javase-17-ubi8:1.2.30-RELEASE`).
  - You can find the latest versions in the [Corporate container images catalog](https://image-version.sgtech.gs.corp/).

!!! warning
    Be aware that Dockerfiles may have several `FROM` lines. Ensure that all lines starting with `FROM` are updated.

This change will ensure your image is built with the latest version, resolving most Sysdig-detected vulnerabilities.
If you are already using the latest version of your base image, you can request a new version to address the vulnerability using Service Now.
Refer to the categorization at the end of the [Corporate container images catalog](https://image-version.sgtech.gs.corp/).

#### Addressing Container Vulnerabilities

The following flowchart shows how to address container vulnerabilities:

![Container-Vulnerability](images/vulnerabilities-use-cases.drawio)
