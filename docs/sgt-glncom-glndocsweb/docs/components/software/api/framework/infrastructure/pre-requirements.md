# Pre-requirements

<div class="subtitle" markdown>
On the onboarding process, entity needs to complete some pre-requirements to be able to use the Gluon capabilities. Below are the pre-requirements for APIs.
</div>

## API Deployment Requirements

Entities are required to gather the following information in order to successfully integrate into the Gluon platform.

[Info to be filled by entities](docs/entity-requirements.xlsx)

Users configuration for all environments (CERT, PRE and PRO):

- Apigee: user in Management Server with permission to deploy.
- IBM API Connect: user with permission to deploying API Manager and user with permission to upload files to Datapower.
- Oauth Server: user with permission to create credentials.

 **Infrastructure:**

<u>IBM API Connect deployment:</u>

| Component | Version | Description | Internal documentation |
|-----------|---------|-------------|-----------------|
| IBM API Connect | V 10.0.5.X | Virtual machines with IBM API Connect components installed | N/A |
| SOS | V 16.1.3 | Security component - Oauth Server | [Technical documentation](https://cipdoc.sgtech.dev.corp/workstream/components/sos/) |
| PKM (optional) | V 7.6.0 | Security component - Public Key Manager | [Technical documentation](https://cipdoc.sgtech.dev.corp/workstream/components/pkm/) |
| STS (optional) | V 16.1.3 | Security component - Security Token Service |  [Technical documentation](https://cipdoc.sgtech.dev.corp/workstream/components/sts/) |

**Note**: Gluon allows one Oauth Server configuration in the API Manager installation. If the entity has more than one Oauth Server, it is necessary to create a new API Manager installation for each Oauth Server.
<u>Apigee deployment:</u>

| Component | Version | Description | Internal documentation |
|-----------|---------|-------------|---------------|
| Apigee OPDK| V 4.52.00.x. | APIGEE: Virtual machines with Apigee components installed.| N/A |
| SOS (Europe) | V 16.1.3 | Security component - Oauth Server | [Technical documentation](https://cipdoc.sgtech.dev.corp/workstream/components/sos/) |
| RHSSO (Brazil) | V 7.4   | Security component - Oauth Server | WIP |
| PKM (optional) | V 7.6.0 | Security component - Public Key Manager | [Technical documentation](https://cipdoc.sgtech.dev.corp/workstream/components/pkm/) |
| STS (optional) | V 13.7.1 | Security component - Security Token Service | [Technical documentation](https://cipdoc.sgtech.dev.corp/workstream/components/sts/) |

**Note**: Gluon allows one Oauth Server configuration in the API Manager installation. If the entity has more than one Oauth Server, it is necessary to create a new API Manager installation for each Oauth Server.

<u>Identity provider for authentication:</u> Azure AD (recommended). Authentication from API Managers with Azure AD.

 **Connectivity.**

Open Firewall Rules from the Gluon sources listed [here](../../../../../getting-started/company-management/technical-requirements/firewall-rules.md), to all local entity components used for API deployment:

| Origin | Destinies |
|--------|-----------|
| Management Server | *SOS*, Azure AD, kubernetes platform (both local and Gluon IL/AL) |
| Gateways  | *SOS*, *PKM*, *STS*, kubernetes platform (both local and Gluon IL/AL) |
| Gluon kubernetes platform IL/AL namespace | *Management Server*, *Gateways*, *SOS* |
| Self-hosted runners | *Management Servers*, *Gateways*, *SOS*, *Marketplace*, *STS*, *PKM*, ... (all components used in the deployment local infrastructure) |
| Ephemeral runners | *Management Servers*, *Gateways*, *SOS*, *Marketplace*, *STS*, *PKM*, ... (all components used in the deployment local infrastructure) |

>Components shown in italics are deployed in local infrastructure.

**Note**: For IBM API Connect deployment, entity must open the firewall rules to the local Datapower because there is a policy (set-properties) that needs to upload a file to the Datapower.

 **Configuration.**

[Policies API Deployment 2.0](../tech-components/policies/policies.md)

<!--
## API Subscription Requirements

 **Infrastructure.**

WIP

 **Connectivity.**

WIP

 **Configuration.**

Users configuration for all environments (DEV, CERT, PRE and PRO):
- Oauth Server: user with permission to create credentials.
-->
