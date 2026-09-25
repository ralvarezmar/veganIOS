---
title: Brownfield microservice components - OIDC Role request (EKS+ECR)
---

Guide to be followed by components created from SCF’s Brownfield templates for microservices:

- [(SCF) .NET Microservice](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/dotnet-microservice/)
- [(SCF) PHP Microservice](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/php-micro/)
- (SCF) Java Microservice
- ~~(SCF) Node Microservice~~

## EKS and ECR - OIDC Role request

The SCF Brownfield Microservice components need a role that can be assumed with OIDC from the GitHub repository of the component to upload the image to ECR and deploy the microservice in EKS.
Both tasks will be encompassed under the same role.
It is neccesaty too a trust relationship between the role and the component repository.
These role must be requested via **Service Now** at the following path:

[TECHNICAL CATALOG > Cloud > Public > CGS - SCF - Cloud Platforms](https://santander.service-now.com/com.glideapp.servicecatalog_cat_item_view.do?v=1&sysparm_id=7c3518511bc36150e4909753b24bcbb8&sysparm_link_parent=ce17fabcdb5df7807f668c994b961938&sysparm_catalog=719aafd0db031f448c6c7cde3b9619f8&sysparm_catalog_view=catalog_technical_catalog&sysparm_view=text_search).

On accessing this page, a form will be presented which needs to be filled following the instructions below:

- In the `Operation` field, select **General Support**.
- In the `Description` field, include the following information:
  - **GitHub repository** of the component
  - **Tracking Code** of the project *(this will be the name of the ECR repository that the user will have permission for)*.
  - **AWS Account** (Name and ID).
  - **EKS Name**
  - **Namespace**

### Request example

```txt title="Request Example" linenums="1"
    Hello, we need a role to deploy a EKS+ECR Brownfield microservice in Gluon.
    Details for OIDC Role needed:
    - Repository: **https://github.com/santander-group-xxx-gln/xxx-yyyyyy-zzzzzzzzzzzzz**
    - Tracking Code of the project: **XXXXXX**
    - AWS Account: **cgsd2airaccxxxeksgene001 **(000123456789)
    - EKS Name: **cgsd2airaccxxxeksgene001**
    - Namespace: **xxx-xxxxx-dev**
```

## Pod access to external AWS resources - ServiceAccount request

If the microservice needs to access AWS resources from the AWS project's account, a ServiceAccount must be requested in a different Service Now request at the following path:

[TECHNICAL CATALOG > Cloud > Public > CGS - SCF - Cloud Platforms](https://santander.service-now.com/com.glideapp.servicecatalog_cat_item_view.do?v=1&sysparm_id=7c3518511bc36150e4909753b24bcbb8&sysparm_link_parent=ce17fabcdb5df7807f668c994b961938&sysparm_catalog=719aafd0db031f448c6c7cde3b9619f8&sysparm_catalog_view=catalog_technical_catalog&sysparm_view=text_search).

On accessing this page, a form will be presented which needs to be filled following the instructions below:

- In the `Operation` field, select **General Support**.
- In the `Description` field, include the following information:
  - **GitHub repository** of the microservice component with this need
  - **Source AWS Account** (Name and ID) where is the EKS
  - **EKS Name**
  - **Namespace**
  - The **target AWS account** of the resource that you want to consume (Name and ID)
  - The **IAM policy** that the user needs to assume, with the necessary actions and specific resources

### Request example

```txt title="Request Example" linenums="1"
    Hello, we need a ServiceAccount to access external AWS resources from a microservice.
    Details for IRSA Service Account needed:
    - Repositorie: **https://github.com/santander-group-xxx-gln/xxx-yyyyyy-zzzzzzzzzzzzz**
    - Source AWS Account: **cgsd2airaccxxxeksgene001** (000123456789)
    - EKS Name: **cgsd2airaccxxxeksgene001**
    - Namespace: **xxx-xxxxx-dev**
    - Destination AWS Account: **cgsd2airaccxxxxxxgene001** (000123456789)
    - Policy:

    ```json
    {
      "Effect" : "Allow",
      "Action" : [
        "s3:Get*",
        "s3:List*",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectRetention",
        "s3:PutObjectTagging",
        "s3:PutObjectVersionAcl",
        "s3:PutObjectVersionTagging",
        "s3:DeleteObject",
        "s3:DeleteObjectTagging",
        "s3:DeleteObjectVersion",
        "s3:DeleteObjectVersionTagging",
        "s3-object-lambda:Get*",
        "s3-object-lambda:List*",
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": [
        "arn:aws:s3:::cgsd2airas3xxxxxgene003",  
        "arn:aws:s3:::cgsd2airas3xxxxxgene003/*",
        "arn:aws:kms:eu-west-1:412381778703:key/7fc5f4a6-794d-4175-93c7-dd20092d953b"
      ]
    }
    ```
```
