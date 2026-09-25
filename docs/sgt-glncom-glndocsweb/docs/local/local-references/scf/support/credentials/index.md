---
title: SCF AWS Credentials Guide
---

## Microservice components - User and OIDC Role Request

The components that need to log in to AWS, depending on the type of component, have the following procedures for configuring the credentials:

| Type                                | Description                                                    | Documentation                                   |
| ----------------------------------- | -------------------------------------------------------------- | ----------------------------------------------- |
| Greenfield microservices (EKS+ECR)  | Greenfield microservices guide on configuring AWS Credentials  | [Greenfield Credentials Guide](./greenfield.md) |
| Brownfield microservices (EKS+ECR)  | Brownfield microservices guide on configuring AWS Credentials  | [Brownfield Credentials Guide](./brownfield.md) |

## Non Microservice components - OIDC Role Request

Guide to be followed by components created from SCF’s Brownfield templates for non-microservices.
Among all these templates, there are 3 groups that require different credential requests:

| Type                                     | Description                                                         | Documentation                                   |
| ---------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------- |
| Miscellaneous components                 | [List of components](#miscellaneus-components)                      | [Miscellaneous Credentials Guide](./data.md)             |
| ECR components                           | [List of components](#ecr-components)                               | [ECR Credentials Guide](./ecr.md)               |
| Kafka                                    | [List of components](#kafka-connect-connectors-on-eks-components)   | [Special Cases Guide](./special.md)             |

Check which group your component belongs to in the following list:

### [Miscellaneus components](./data.md)

- **(SCF) Airflow Environment settings**
- **(SCF) Airflow Requirements**
- **(SCF) AWS Quicksight**
- **(SCF) Liquibase Athena**
- **(SCF) Liquibase DocumentDB**
- **(SCF) Liquibase MSSQL**
- **(SCF) Liquibase MySQL**
- **(SCF) Liquibase Oracle**
- **(SCF) Liquibase PostgreSQL**
- **(SCF) Maven Emr**
- **(SCF) Node Lambda**
- **(SCF) Node S3**
- **(SCF) Node S3 Assets**
- **(SCF) Python EMR**
- **(SCF) Python Lambda**
- **(SCF) Python S3**
- **(SCF) Python Sagemaker** (By default, the SCF Python Sagemaker component does not upload images to an ECR. However, if this functionality is required, an additional ECR request must be made to enable it)
- **(SCF) Python Virtual Environment**
- **(SCF) S3 Upload**

### [ECR components](./ecr.md)

- **(SCF) Image Upload**
- **(SCF) Python Sagemaker** (By default, the SCF Python Sagemaker component does not upload images to an ECR. However, if this functionality is required, an additional ECR request must be made to enable it)

### [Kafka Connect Connectors on EKS components](./special.md)

- **(SCF) Kafka Connector EKS**
