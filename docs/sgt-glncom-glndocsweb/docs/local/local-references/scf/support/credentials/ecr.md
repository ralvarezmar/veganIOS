---
title: ECR components - OIDC Role request Guide
---

Guide to be followed by components created from SCF’s Brownfield templates for Miscellaneus components:

**(SCF) Image Upload**
**(SCF) Python Sagemaker** (By default, the SCF Python Sagemaker component does not upload images to an ECR. However, if this functionality is required, an additional ECR request must be made to enable it)

## ECR components - OIDC Role request

The SCF Brownfield ECR components needs a role that can be assumed with OIDC from the GitHub repository of the component to push and pull images to ECR.
This role must be requested via **Service Now** in the following path:

[TECHNICAL CATALOG > Cloud > Public > CGS - SCF - Cloud Platforms](https://santander.service-now.com/com.glideapp.servicecatalog_cat_item_view.do?v=1&sysparm_id=7c3518511bc36150e4909753b24bcbb8&sysparm_link_parent=ce17fabcdb5df7807f668c994b961938&sysparm_catalog=719aafd0db031f448c6c7cde3b9619f8&sysparm_catalog_view=catalog_technical_catalog&sysparm_view=text_search).

On accessing this page, a form will be presented which needs to be filled following the instructions below:

- In the `Operation` field, select **General Support**.
- In the `Description` field, include the following information:
- **GitHub repository** of the component
- **AWS Account** (Name and ID)
- **ECR Repository name** where permissions are needed

### Request example

```txt title="Request Example" linenums="1"
    Hello, we need a role to push Docker images to ECR from a SCF Brownfield ECR compoenent in Gluon.
    Details for OIDC Role needed:
    - Repository: **https://github.com/santander-group-xxx-gln/xxx-yyyyyy-zzzzzzzzzzzzz**
    - AWS Account: **cgsd2airaccxxxxxxgene001**(000123456789)
    - ECR Repository name: **cwei1airecrxxxxxxgene001**
```
