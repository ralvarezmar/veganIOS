---
title: Cloud Provider
hide:
  - toc
---

## Introduction

The purpose of this documentation is to provide the technical information needed to deploy a Kubernetes Cluster resource in AWS and/or AZ provider.

## Services Deployed by the component

|Service|Description|
|-------|-----------|
|[Amazon Elastic Kubernetes Service](./aws.md)| Amazon Elastic Kubernetes Service (Amazon EKS) is a managed service that makes it easy for you to run Kubernetes on AWS without needing to stand up or maintain your own Kubernetes control plane. |
|[Azure Kubernetes Service](./az.md)| Azure Kubernetes Service (AKS) is a managed Kubernetes service that you can use to deploy and manage containerized applications. You need minimal container orchestration expertise to use AKS. |

## Stages

Take a look to the main steps executed for Kubernetes Cluster components.

||**Pre-conf**|**Infrastructure provisioning**|**Post-Conf**|
|:---:|:---:|:---:|:---:|
|**Kubernetes Cluster**||:material-check-circle-outline:|:material-check-circle-outline:|

<div class="cards row-2" markdown>

- ### AZ

    ---

    This page contains information about the parameters that can be used to deploy a Kubernetes resource in Azure.

    <br>

    ---

    [:material-arrow-right: Azure Provider](./az.md){ .md-button }

- ### AWS

    ---

    This page contains information about the parameters that can be used to deploy a Kubernetes resource in AWS.

    <br>

    ---

    [:material-arrow-right: AWS Provider](./aws.md){ .md-button }
