---
title: Cloud Provider
hide:
  - toc
---

## Introduction

The purpose of this documentation is to provide the technical information needed to deploy an Object Storage resource in AWS and/or AZ provider.

## Services Deployed by the component

|Service|Description|
|-------|-----------|
|[Amazon Simple Storage Service](./aws.md)| Amazon Simple Storage Service (Amazon S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance. Customers of all sizes and industries can use Amazon S3 to store and protect any amount of data for a range of use cases, such as data lakes, websites, mobile applications, backup and restore, archive, enterprise applications, IoT devices, and big data analytics. Amazon S3 provides management features so that you can optimize, organize, and configure access to your data to meet your specific business, organizational, and compliance requirements. |
|[Azure Storage Account](./az.md)| An Azure Storage Account contains all of your Azure Storage data objects: blobs, files, queues, tables, and disks. The storage account provides a unique namespace for your Azure Storage data that is accessible from anywhere in the world over HTTP or HTTPS. Data in your Azure storage account is durable and highly available, secure, and massively scalable. |

## Stages

Take a look to the main steps executed for Object Storage components.

||**Pre-conf**|**Infrastructure provisioning**|**Post-Conf**|
|:---:|:---:|:---:|:---:|
|**Object Storage**||:material-check-circle-outline:|:material-check-circle-outline:|

<div class="cards row-2" markdown>

- ### AZ

    ---

    This page contains information about the parameters that can be used to deploy an ObjectStorage resource in Azure.

    <br>

    ---

    [:material-arrow-right: Azure Provider](./az.md){ .md-button }

- ### AWS

    ---

    This page contains information about the parameters that can be used to deploy an ObjectStorage resource in AWS.

    <br>

    ---

    [:material-arrow-right: AWS Provider](./aws.md){ .md-button }

</div>
