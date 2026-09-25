---
title: Kafka Connect Connectors on EKS - OIDC Role Request
---

Guide to be followed by components created from (SCF) Kafka Connector EKS template.

For components based on the Kafka Connectors template, a role is required that can be assumed with OIDC from the GitHub repository of the component to configure the Kafka Connector in EKS.
It is also necessary to establish an OIDC trust relationship between the role and the component repository.
This role must be requested via **Service Now** at the following path:

[TECHNICAL CATALOG > Cloud > Public > CGS - SCF - Cloud Platforms](https://santander.service-now.com/com.glideapp.servicecatalog_cat_item_view.do?v=1&sysparm_id=7c3518511bc36150e4909753b24bcbb8&sysparm_link_parent=ce17fabcdb5df7807f668c994b961938&sysparm_catalog=719aafd0db031f448c6c7cde3b9619f8&sysparm_catalog_view=catalog_technical_catalog&sysparm_view=text_search).

On accessing this page, a form will be presented which needs to be filled following the instructions below:

- In the `Operation` field, select **General Support**.
- In the `Description` field, include the following information:
- **GitHub repositorie** of the component
- **AWS Account** (Name and ID)
- **EKS Name**
- **Namespace**

### Request example

```txt title="Request Example" linenums="1"
    Hello, we need a role to Kafka Connect Connectors on EKS component in Gluon.
    Details for OIDC Role needed:
    - Repositorie:** https://github.com/santander-group-xxx-gln/xxx-yyyyyy-zzzzzzzzzzzzz**
    - AWS Account: **cgsd2airaccxxxeksgene001 **(000123456789)
    - EKS Name: **cgsd2airaccxxxeksgene001**
    - Namespace: **xxx-xxxxx-dev**
```
