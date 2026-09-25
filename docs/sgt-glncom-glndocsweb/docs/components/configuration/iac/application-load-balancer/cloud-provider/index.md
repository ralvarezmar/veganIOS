---
title: Cloud Provider
hide:
  - toc
---

## Introduction

The purpose of this documentation is to provide the technical information needed to deploy an Application Load-Balancer resource in AWS and/or AZ provider.

## Services Deployed by the component

|Service|Description|
|-------|-----------|
|[AWS Elastic Load Balancer](./aws.md)| AWS Elastic Load Balancing automatically distributes your incoming traffic across multiple targets, such as EC2 instances, containers, and IP addresses, in one or more Availability Zones. |
|[Azure Application Gateway](./az.md)| Azure Application Gateway is a web traffic (OSI layer 7) load balancer that enables you to manage traffic to your web applications. |

## Stages

Take a look to the main steps executed for Application Load  Balancer components.

||**Pre-conf**|**Infrastructure provisioning**|**Post-Conf**|
|:---:|:---:|:---:|:---:|
|**Application Load  Balancer**||:material-check-circle-outline:|:material-check-circle-outline:|

<div class="cards row-2" markdown>

- ### AZ

    ---

    This page contains information about the parameters that can be used to deploy an Application Load Balancer resource in Azure.

    <br>

    ---

    [:material-arrow-right: Azure Provider](./az.md){ .md-button }

- ### AWS

    ---

    This page contains information about the parameters that can be used to deploy an Application Load Balancer resource in AWS.

    <br>

    ---

    [:material-arrow-right: AWS Provider](./aws.md){ .md-button }

</div>
