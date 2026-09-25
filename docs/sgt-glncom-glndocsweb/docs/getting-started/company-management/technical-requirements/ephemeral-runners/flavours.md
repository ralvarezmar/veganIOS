---
title: Runners Flavours
---

In this document we will discuss the different technologies included in the images we maintain.

Runners have two types of images: core and android.

These images are deployed with different cpu and memory resources requests and limits reflected in the "size" of the deployment and it is given in the labels as explained later in this document.

## Common technologies of both maintained images

### General applications

- wget
- curl
- git
- jq
- make
- tar
- podman
- buildah
- golang
- sysdig-cli-scanner
- ODBC
- liquidbase 4.30.0

### CD applications

- helm 3.13.3
- helm 3.9.0
- oc
- gcloud
- github-cli
- kubectl

## Core Image

### Java versions

- adoptopenjdk-8.0.422+5
- adoptopenjdk-11.0.20+8
- adoptopenjdk-17.0.8+7
- adoptopenjdk-21.0.2+13.0.LTS
- oracle-graalvm-17.0.11
- oracle-graalvm-21.0.1
- java-se-ri-7u75-b13
- java-se-ri-8u41-b04

### Maven versions

- 3.8.4
- 3.9.4
- 3.9.5

### Node versions

- 8.17.0
- 10.24.1
- 12.22.12
- 14.21.3
- 16.20.2
- 18.18.2
- 18.20.2
- 19.9.0
- 20.14.0

### Python versions

- 3.9.18
- 3.10.11
- 3.11.5

### CD applications

- ansible 7.7.0@3.9.18
    - Community collection for postgresql
- terraform 1.6.6
- terraform 1.7.5
- terraform 1.8.3
- awscli
- azure-cli
- powershell-core

## Android Image

- adoptopenjdk-11.0.20+8
- adoptopenjdk-17.0.8+7
- adoptopenjdk-21.0.2+13.0.LTS
- maven 3.9.5
- gradle 8.6
- sdkmanager tools
- sdkmanager platform tools

## Runner Labels

Runner labels are separated by size, infrastructure and environment in which they are deployed. Here is how to compose the label separated by -:

- Environment: pro, pre or dev.
- Size:
    - xs: For scripting, deployments or any task that does not require many resources without cache.
    - s: For scripting, deployments or any task that does not require many resources with cache.
    - m: For medium builds with cache.
    - l: For resource-intensive builds with cache.
    - android: For android builds with cache.
- Infrastructure: ohe or aws

### Runner labels example

Environment pro in an AWS cluster:

- pro-xs-aws
- pro-s-aws
- pro-m-aws
- pro-l-aws
- pro-android-aws

Environment pro in an Openshift cluster:

- pro-xs-ohe
- pro-s-ohe
- pro-m-ohe
- pro-l-ohe
- pro-android-ohe

Environment pre in an Openshift cluster:

- pre-xs-ohe
- pre-s-ohe
- pre-m-ohe
- pre-l-ohe
- pre-android-ohe

## Mandatory labels

The labels that must be displayed for app360 workflows to work correctly are:

- pro-xs-{INFRASTRUCTURE}
- pro-s-{INFRASTRUCTURE}
- pro-m-{INFRASTRUCTURE}
- pro-l-{INFRASTRUCTURE}

Workflows detect the organization's infrastructure depending on a global variable.

```bash
INFRA_CI
INFRA_BASE
```

## Docker alternatives

Due to security issues, the use of docker is forbidden, so two alternatives for building docker images are installed: podman and buildah.

Our recommendation is to use buildah, as it has better performance than podman when building large images, even compiling 4 times faster.

### Other sections in Ephemeral runners

<div class="cards row-3" markdown>

- #### Ephemeral Runners Adoption Process

    ---
    Learn about the adoption process and infrastructure supported.

    [:white_check_mark: Learn about the adoption process](./adoption-process/index.md)

- #### Image Governance

    ---
    Look at the ephemeral runner Image Governance information.

    [:recycle: Image Governance](./image-governance.md)

</div>
