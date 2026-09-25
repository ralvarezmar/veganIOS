---
title: Cloud Provider
hide:
  - toc
---

## Introduction

The purpose of this documentation is to provide the technical information needed to deploy a Log Storage resource in AWS and/or AZ provider.

## Services Deployed by the component

|Service|Description|
|-------|-----------|
|[Amazon CloudWatch](./aws.md)| Amazon CloudWatch monitors your Amazon Web Services (AWS) resources and the applications you run on AWS in real time. You can use CloudWatch to collect and track metrics, which are variables you can measure for your resources and applications. |
|[Azure Log Analytics Workspace](./az.md)| A Log Analytics workspace is a data store into which you can collect any type of log data from all of your Azure and non-Azure resources and applications. |

## Stages

Take a look to the main steps executed for Kubernetes Cluster components.

||**Pre-conf**|**Infrastructure provisioning**|**Post-Conf**|
|:---:|:---:|:---:|:---:|
|**Log Storage**||:material-check-circle-outline:||

<div class="cards row-2" markdown>

- ### AZ

    ---

    This page contains information about the parameters that can be used to deploy a Log Storage resource in Azure.

    <br>

    ---

    [:material-arrow-right: Azure Provider](./az.md){ .md-button }

- ### AWS

    ---

    This page contains information about the parameters that can be used to deploy a Log Storage resource in AWS.

    <br>

    ---

    [:material-arrow-right: AWS Provider](./aws.md){ .md-button }

</div>
