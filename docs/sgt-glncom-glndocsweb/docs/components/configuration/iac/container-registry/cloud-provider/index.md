---
title: Cloud Provider
hide:
  - toc
---

## Introduction

The purpose of this documentation is to provide the technical information needed to deploy a Container Registry resource in AWS and/or AZ provider.

## Services Deployed by the component

|Service|Description|
|-------|-----------|
|[Amazon Elastic Container Registry](./aws.md)| Amazon Elastic Container Registry (ECR) is a fully-managed Docker container registry that makes it easy for developers to store, manage, and deploy Docker container images. |
|[Azure Container Registry](./az.md)| Azure Container Registry (ACR) allows you to build, store, and manage container images and artifacts in a private registry for all types of container deployments. |

## Stages

Take a look to the main steps executed for Container Registry components.

||**Pre-conf**|**Infrastructure provisioning**|**Post-Conf**|
|:---:|:---:|:---:|:---:|
|**Container Registry**||:material-check-circle-outline:|:material-check-circle-outline:|

<div class="cards row-2" markdown>

- ### AZ

    ---

    This page contains information about the parameters that can be used to deploy a Container Registry resource in Azure.

    <br>

    ---

    [:material-arrow-right: Azure Provider](./az.md){ .md-button }

- ### AWS

    ---

    This page contains information about the parameters that can be used to deploy a Container Registry resource in AWS.

    <br>

    ---

    [:material-arrow-right: AWS Provider](./aws.md){ .md-button }

</div>
