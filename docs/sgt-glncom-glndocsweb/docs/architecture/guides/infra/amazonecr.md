# DI2 - Amazon Elastic Container Registry (ECR)

## Key points

  - As a regional service, there will be an ECR service per Landing Zone.
  - Creation and configuration of repositories:
    - One repository per technical application.
    - It is proposed the creation and configuration process be carried out during the onboarding of the technical application.
    - The repository creation and configuration process must include the permissions described in section ***3.1 ECR Repositories administration*** of the document [Amazon ECR Authentication & Authorization](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/Amazon-ECR-Authentication-%26-Authorization.aspx){:target="_blank"},
    to allow push and pull images, as well as the default retention policy indicated below.
    - The other sections of that document describe how to push images to the repository and how to pull images from the repository.
    - It is mandatory to tag the published images to avoid their deletion by the default retention policy.
    - Apart from the default retention policy, each organization may include additional retention policies for tagged images according to their needs.

## Default untagged lifecycle policy

``` json
default_lifecycle_policy = [
  {
    "rulePriority" : 1,
    "description" : "Expire images older than 1 day",
    "selection" : {
      "tagStatus" : "untagged",
      "countType" : "sinceImagePushed",
      "countUnit" : "days",
      "countNumber" : 1
    },
    "action" : {
      "type" : "expire"
    }
  }
]
```

## Related to

|Name|Description|External Link|
|---|---|---|
| Amazon Elastic Container Registry (ECR) TRA | Technical Reference Architecture to define and standardize the use of Amazon ECR | [Amazon elastic container registry](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/Amazon-elastic-container-registry.aspx?web=1){:target="_blank"} |
| Amazon ECR Authentication & Authorization | Specification of the use cases for the consumption of ECR service and the design of a secure authentication strategy for this use cases | [Amazon ECR Authentication & Authorization](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/Amazon-ECR-Authentication-%26-Authorization.aspx){:target="_blank"} |
