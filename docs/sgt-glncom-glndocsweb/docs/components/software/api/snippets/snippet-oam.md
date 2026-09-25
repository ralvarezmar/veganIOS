## Infrastructure

### OAM Configuration

To deploy APIs and Products, the parameters of the target infrastructure must be configured in the **Gluon Application Model** component of the technical application,
[**configuring the data**](../framework/infrastructure/oam-configuration.md) necessary depending on the type of API exposure.

### Configure environments

The API Deployment 2.0, API Product, API Subscription and Key Set components allows the same component to be deployed in a multi-environment and multi-gateway setup.
This configuration must be done in the ./gluon/cd path.

By default, the component is created with the folders cert, pre, and pro, which cover the most common use case. Each of these folders corresponds to an environment in which
you want to deploy the API or the Product. If, for example, you want to deploy in two production environments called pro-shadow and live, the folder structure that should be created in the
cd folder is dev, pre, pro-shadow, and live, each with the cd.yml file where the infrastructure to be deployed must be configured.

For it to work correctly, the name of the folder must exactly match the name of the "name" property (in the example shown below,
it would be the cert value) of the oam-application-definition.yml file, of the Gluon Application Model component.

Below is an example of the configuration of a certification environment, called cert, where two infrastructures have been configured to deploy, one for
IBM API Connect and another for Apigee. Many properties have been omitted for this example, but for it to work correctly, the rest of the
mandatory data must be configured.

``` yaml title="oam-application-definition.yml"
environments:
  - name: cert
    type: certification
    infrastructures:
      - id: CI00000000097
        properties:
          type: IBM
          credentialUserId: APICONNECT_USER_DEV
          credentialPassId: APICONNECT_USER_DEV_PASS
          company: gluon
          exposure: intranet
          security-type: core
          (...)

      - id: CI00000000098
        properties:
          type: APIGEE
          credentialUserId: APIGEE_USER_DEV
          credentialPassId: APIGEE_USER_DEV_PASS
          company: gluon
          exposure: intranet
          security-type: core
          (...)

      - id: CI00000000099
        properties:
          type: AWS_API_GATEWAY
          aws-access-key-id: AWS_ACCESSKEY_DEV
          aws-secret-access-key: AWS_SECRET_DEV
          company: gluon
          exposure: intranet
          security-type: core
          (...)
```

The next step is to configure the cd.yml file, where you can set up the infrastructures where the component will be deployed for that environment. For each one, the following properties must be configured:

| **Property** | **Description**  | **Example** |
|--- |--- |--- |
| ci_id   | Identifier of the infrastructure in the oam-application-definition.yml file | CI00000000097 |
| configurationFiles | Path to the API configuration file in that environment | src/properties/cert/values-ibm.yml |

Following the previous example from the oam-application-definition.yml file, the content of the cd.yml file to deploy on Apigee and IBM API Connect would be as follows:

``` yaml title="cd.yml"
- ci_id: CI00000000097
  configurationFiles:
  - src/properties/cert/values-ibm.yml

- ci_id: CI00000000098
  configurationFiles:
  - src/properties/cert/values-apigee.yml

- ci_id: CI00000000099
  configurationFiles:
  - src/properties/cert/values-aws.yml
```

> !IMPORTANT - Considerations:
>
> - The workflow will deploy on all infrastructures that are included in the cd.yml file of the environment in which it is going to be executed.
> - The infrastructures included in the cd.yml file must be registered in the environment in the oam-application-definition.yml file.
> - For APIs, when creating the component, the security profile is indicated, an infrastructure should not be included in the cd.yml file that is not compatible with the security profile.
> - In the current version, in the case of **subscriptions to API Products from other entities**, for it to work correctly, the **ci_id** identifier configured in the OAM **must be the same** as the one configured in **application owner of the API Product**.
Therefore, the same infrastructure must be registered in the OAM file of the technical applications of the API Product (producer) and the API Subscription (consumer).
> For example, a core infrastructure should not be included if the security profile is Authorization Code.
