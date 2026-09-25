---
title: Miscellaneous components - OIDC Role request Guide
---

Guide to be followed by components created from SCF’s Brownfield templates for Miscellaneous components:

**(SCF) Airflow Environment settings**
**(SCF) Airflow Requirements**
**(SCF) AWS Quicksight**
**(SCF) Liquibase Athena**
**(SCF) Liquibase DocumentDB**
**(SCF) Liquibase MSSQL**
**(SCF) Liquibase MySQL**
**(SCF) Liquibase Oracle**
**(SCF) Liquibase PostgreSQL**
**(SCF) Maven Emr**
**(SCF) Node Lambda**
**(SCF) Node S3**
**(SCF) Node S3 Assets**
**(SCF) Python EMR**
**(SCF) Python Lambda**
**(SCF) Python S3**
**(SCF) Python Sagemaker** (By default, the SCF Python Sagemaker component does not upload images to an ECR. However, if this functionality is required, an additional ECR request must be made to enable it)
**(SCF) Python Virtual Environment**
**(SCF) S3 Upload**

## Miscellaneus components - OIDC Role request

The SCF Brownfield No-Microservice Miscellaneus components need a role that can be assumed with OIDC from the GitHub repository of the component,
this trust relationship between the role and the repositories of the components of a Gluon application must be requested via **Service Now** at the following path:

[TECHNICAL CATALOG > Cloud > Public > CGS - SCF - Cloud Platforms](https://santander.service-now.com/com.glideapp.servicecatalog_cat_item_view.do?v=1&sysparm_id=7c3518511bc36150e4909753b24bcbb8&sysparm_link_parent=ce17fabcdb5df7807f668c994b961938&sysparm_catalog=719aafd0db031f448c6c7cde3b9619f8&sysparm_catalog_view=catalog_technical_catalog&sysparm_view=text_search).

On accessing this page, a form will be presented which needs to be filled following the instructions below:

- In the `Operation` field, select **General Support**.
- In the `Description` field, include the following information:
    - **Gluon Application**
    - **AWS account** of the resources (Name and ID)

### Request example

```txt title="Request Example" linenums="1"
    Hello, we need to integrate our application’s brownfield components with OIDC.
    Details of Brownfield miscellaneous component(s):
    - Gluon Application: [**https://gluon.gs.corp/gluon/companies/XX/applications/YYY/detail**](https://gluon.gs.corp/gluon/companies/XX/applications/YYY/detail)
    - AWS Account: **cgsd2airaccxxxxxxgene001** (000123456789)
```
