# IBM API Connect v10 - Openshift deployment

## Deployment Topology

### Introduction

IBM API Connect, a certified technology within our software stack, it has been adapted to support the API Connect V10 deployment in OpenShift aligned with Operational PaaS deployment strategy.

### API Connect Components

There are four major components in API Connect v10.0.5.X LTS

![Api Connect Components](../assets/images/api-connect-components.png){: .image-popup align="center" style="width:40%"}

- API Management. Stores all of the cloud configuration, and controls communication between the other components within API Connect.
Manages the operations of the various components in the API Connect and provides the tools to interface with the various components.
The Cloud Manager and API Manager user interfaces run on the Management server.

- API Analytics. Provides analytic functions that collect and store information about APIs and API users.

- API Gateway. Processes and manages security protocols and stores relevant user and appliance authentication data. The Gateway also provides assembly functions that enable APIs to integrate with various endpoints, such as databases or HTTP-based endpoints.

- Developer Portal. (Out of Scope, Developer Portal Capabilities will be provided by Gluon Developer Portal )

#### API Connect Components - Management Service

The Management Service provides: the API Manager, the Cloud Manager, Platform Management API and Consumer Management API

- The Cloud Manager controls the infrastructure of the API Cloud. This is typically accessed by Infrastructure or Operation teams only.

- The API Manager controls the creation, publication, and management of APIs.

- The API Test and Monitor tool provides a framework and facility for testing APIs

- The Management Service is made up of the following components:

| Component | Purpose |
|-----------|-------------|
| postgres | Database for the management cluster |
| apim | Core microservices, handling communications with the other management microservices |
| ui | Graphical User Interface for the Cloud Manager and API Manager |
| juhu | Coordinates authentication and token management for API Management service |
| ldap | User authentication when using a LDAP user registry |
| lur | Branch of the API definition repository |
| client-downloads-server | Controls downloading of APIC CLI and Designer Tools |
| analytics-proxy | Handles communication with the analytics service |
| portal-proxy | Handles communication with the portal service|
| taskmanager | Manages internal tasks within the management cluster|
| natscluster | Handles messages between the management microservices|
| websocket-proxy | Provides proxy for WebSocket connection|<br>

#### API Connect Components - Analytics Service

The Analytics Service is built on the OpenSearch open source - real-time distributed search and analytics engine - and performs the following tasks:

- Storing API event logs as they are processed from the Gateway Service
- Processing API event logs form the gateway
- Providing visualizations of the aggregated metric data from the API events
- Surfacing the API calls raw log data to help developers debug
- Off-loading API event records to third-party application, via for example Syslog, Kafka, and HTTP

The Analytics Service is made up of the following components

| Component | Purpose |
|-----------|-------------|
| director | Host analytics webserver for RESTful API calls |
| mtls-gw | Entry point for communication with analytics microservices |
| ingestion | Processing analytics data for storage and off-loading to third party systems |
| storage | Handles datastore for analytics data |<br>

#### API Connect Components - Gateway Service

The API gateway Service is still based on IBM DataPower and has the following component:

| Component | Purpose |
|-----------|-------------|
| gateway | DataPower runtime |<br>

#### API Connect Components - Operators

Operators allow the deployment of API Connect subsystems across multiple namespaces on OpenShift. There are three operators:

| Operator | Purpose | Provided Apis |
|-----------|-------------|-------------|
| Common Service Operator | The ibm-common-service-operator is a bridge to connect IBM Cloud Paks and Operand Deployment Lifecycle Manager (ODLM) with IBM Cloud Platform Common Services |CommonService|
| Api Connect Operator | The Api Connect Operator packages, deploys, and manages IBM Api Connect as a Kubernetes application |Analytics backup task, Analytics cluster, Analytics restore task, API Connect cluster, Event Endpoint Manager ...|
| Datapower Operator | The DataPower Operator packages, deploys, and manages IBM DataPower Gateway as a Kubernetes application |DataPowerService, DataPowerMonitor, DataPowerMustGather, DataPowerMustGatherManager|<br>

### Requirements

- Each Gateway Service must be sized to handle peak TPS throughput
- Each Datacenter must be designed to support peak TPS.
- System requires the availability defined in each entity
- Ability to restore API Connect configuration in Disaster Recovery scenario with RPO of close to 0
- System requires RTO 2 hours for Management
- System requires RTO immediate for Analytics and Gateway
- API Connect Platform availability is dependent on the availability of OpenShift and VMware instances that API Connect and DataPower are installed on
- Must support TLSv1.2 and above
- At least 1-way TLS communication between sub-systems
- Connection to third-party dependencies (LDAP, SMTP, Observability Systems, Logging  etc.)
- Affinity of nodes. Deploy to the openshift IBM cluster on dedicated nodes, to isolate any problem of the product from the rest of the cluster.
Each namespace will have as many gateways as exposures are required. In Kubernetes you will only have a kubernetes service per exposition.
- Note: Specific regulatory compliances are out of scope.

### Deployment Topology **Two Site Active-Warm Standby**

![Two Site Active-Warm Standby](../assets/images/Two-Site-Active-Warm-Standby.png){: .image-popup align="center" style="width:50%"}

Characteristics:

- Requires two sites, each site has its own dedicated OpenShift Cluster
- Management services deployed as Active-Warm standby.  Gateway and Analytics services Active-Active
- When outage of primary site occurs manual intervention is required to enable management services
- During maintenance process both sites are unavailable
- No syncing of Rate Limit quotas and Token Revocation. Each Cluster has its own Quota enforcements

### Components Architecture

It's recommended for each gateway to be related to a catalog.

![Api Connect Gateways - Catalogs](../assets/images/api-connect-gws-catalogs.png){: .image-popup align="center" style="width:70%"}

However, it also supported a single catalog per domain-namespace with a designated space for each exposition

![Api Connect Gateways - Catalogs - Spaces](../assets/images/api-connect-gws-catalogs-spaces.png){: .image-popup align="center" style="width:70%"}

There are two types of namespaces: api connect namespaces for the management plane of api connect , and business namespaces.

In the following image it is shown a general view of the Api Manager Component Architecture:

![Global View Exposition](../assets/images/general-exposition.png){: .image-popup align="center" style="width:70%"}

### Exposition

The strategy is to deploy one gateway service per exposition within namespace.

The following primary categories have been identified: Internet Client, Internet Core, Third Parties , Intranet Client , Intranet Core and Sandbox. It is also possible to have more exposition use cases depending on the needs

#### Touchpoints Exposition Internet

- Internet exposure: It is recommended to be done from a cluster in DMZ back. It can also be deployed the gateway on intranet but then requires additional F5 to reach Intranet with DMZ Back and the internet.

#### Touchpoints Exposition Intranet

- Intranet Client (Oauth) exposition:  The gateway will be in a cluster on intranet. It is also permissible that a touchpoint that is in intranet goes to DMZ back to consume an Api.
- Intranet Core (JWT) exposition: Has been implemented in a cluster in intranet despite the need for interdomain traffic deployed in DMZ back and the gateway would be internet core.

#### Interdomain Exposition

- It is similar to previous case. Typically it will be deployed in intranet and the communication will be done in intranet.
But also could be the case, in which one is deployed in intranet and another in DMZ back, because the application it is only deployed in DMZ back.

#### OAuth Integration

OAuth token validation must be offloaded to the third-party Open ID Connect (OIDC) provider by using the Introspection URL.

![Two Site Active-Warm Standby](../assets/images/oauth-introspection-ibm.png){: .image-popup align="center" style="width:50%"}

It is necessary to configure the following three urls of the oauth server:

- Authorization URL : An authorization URL where the resource owner grants authorization to the client application to access a protected resource. Example: <https://example.com/oauth2/authorize>
- Token URL : A token request URL where the client application exchanges an authorization grant for an access token. Example: <https://example.com/oauth2/token>
- Introspect URL : The introspection URL is where the API gateway validates the access tokens that are issued by the third party provider. Example: <https://example.com/oauth2/introspect>
- All the scopes that will be supported

For more information please review the following IBM official link : [10.0.5.x LTS](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=connect-oauth-introspection-third-party-oauth-providers)

#### Detailed Topology Diagram

#### Full Openshift Deployment Topology

![Detailed Diagram Full](../assets/images/detailed-exposition-diagram-mngplane-openshift.png){: .image-popup align="center" style="width:65%"}

#### Mixed Deployment Topology with Management Plain in OHE-VMWARE and Runtime in Openshift

![Detailed Diagram Mixed](../assets/images/detailed-exposition-diagram-mngplane-iaas.png){: .image-popup align="center" style="width:65%"}

### Gateway Deployment Configuration

#### Introduction

The previous strategy was based on a gateway in iaas and on a multitude of files and extensions that do not fit when we have a gateway in kubernetes and a simplified solution that allows scaling.
[Official documentation](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=integration-installing-two-data-center-deployment-openshift)

#### Getting the Files from repositories

To Get started with the helm charts, please download helm charts from below repositories:

[Gateway Cluster](https://github.com/santander-group-shared-assets/gln-apiconnect-gatewaycluster-chart)

[Management Cluster](https://github.com/santander-group-shared-assets/gln-apiconnect-gatewaycluster-chart)

[Analytics Cluster](https://github.com/santander-group-shared-assets/gln-apiconnect-analyticscluster-chart)

Structure

The generated repository has a structure similar to the following:

``` bash
Repository
├──templates
|    ├──admin-credentials.yaml
|    ├──ca-secret.yaml
|    ├──certificates.yaml
|    ├──gatewaycluster.yaml
|    ├──issuer.yaml
|    ├──route.yaml
|    ├──domain-config.yaml
├──local
|    ├──domains
|    ├──config
├── Chart.yaml
├── values.yaml
```

- admin-credentials: This file will create a secret to login into UI with admin credentials.
- ca-secret & certificates.yaml: Certificates required to create datapower gateway, we are creating certificates.yaml and ca-secrets which is used to sign the UI portal.
- route.yaml: To order to access webUI, we need to create a route on port 9090.
- domain-configmap.yaml: To create config-maps related to domain, we use this template to create multiple domains related config-maps.
- local: This directory contains details of domain and config details which will assist domain-configmaps to populate in UI
- issuer.yaml: Once certificates are generated. Those are required to be approved by the issuer.yaml
- Values.yaml: Defining the values inside the helm template folder charts.

Datapower Operator includes many features for management and deployment.

- API Migration – As new API  versions are released, the automatic changes in any existing CRDs are defined here.

- Configuration Management – The Datapower will automatically deploys and manages any resources with the DataPower service custom resource spec.

- IBM Entitled Registry – Datapower Images can be automatically pulled from the IBM Entitled registry.

- Datapower Monitor – DataPower pod lifecycle and Peering eventsare tracked through the Datapower monitor.

- Operand Upgrades – The Datapower Operator can be upgraded automatically or manually via the stateful set.

- Pod Autoscaling – Datapower pods can be scaled in relation to memory and CPU usage.

#### CA Certificates types

API Connect creates self-signed CA certificates to sign all the API connect end-entity certificates.
The CA certificates are :

- ingress-ca:    used by ingress-issuer. The ingress-ca signs all user-facing and inter-subsystem certificates.
- management-ca:  signs all t he management intra-subsystem certificates.
- portal-ca:  signs all the portal intra-subsystem certificates.
- analytics-ca:   signs all the analytics intra-subsystem certificates.

#### Inspecting the components

Inspecting the components in your local repository

Once you have the device properly configured, the first step is to clone the project locally.

The next step is to clone the project locally, to do this, click on the "Code" button and copy the URL that appears in the HTTPS tag.

git clone repo-url

After executing the command, the project should appear in the user's selected local directory.

#### Infrastructure

You have to request the following infrastructure resources.

Registry
Project: You need a project in the registry (Harbor) to upload your image.
Credentials: user/password with privileges to upload images to the project.

Openshift
Namespace: You need a namespace in the OCP cluster to deploy your microservice in the DEV, PRE and PRO environments.
Credentials: Service Account with the credentials to deploy in the namespace.

#### Helm Chart Configuration

In this step,  we are going to define the necessary parameters so that the helm chart can deploy the Datapower Gateway correctly in the configured environment.

The variables to be modified are ca-secret details, issuer details, certificates details, details and the access to the specified OCP cluster namespace.

##### Configuration File -  values.yaml

``` yaml
Gateway Cluster:
  name of the cluster: <>
  version: <>
  profile: <>
  gatewayEndpointIssuer: <>
  gatewayEndpointHostname: <>
  gatewayEndpointSecret: <>
  gatewayManagerIssuer: <>
  gatewayManagerEndpointHostname: <>
  gatewayManagerEndpointSecret: <>
  apicGatewayServiceTlsSecret: <>
  apicGatewayPeeringTlsSecret: <>
  license: L-VQYA-YNM22H
  use: production/nonproduction
```

Parameters in values.yaml

| Variable | Description | Examples |
|-----------|-------------|-------------|
| name: admin-credentials| Host analytics webserver for RESTful API calls | admin-credentials |
| email: YWRtaW5AYXBpY29ubmVjdC5uZXQ=| Email address in base64 format| YWRtaW5AYXBpY29ubmVjdC5uZXQ=|
| password: NysmMno7P3ZyXTskKlRtJXtGcTdbdm14| Password in in base64 format| NysmMno7P3ZyXTskKlRtJXtGcTdbdm14|
| name: <>| Name of the issuer| Apim-issuer |
| caName: <>| Name of the caName| Apim-ca-issuer |
| casecret:| - | - |
| name:| Name of the secret key| apic-dp-ingress-ca |
| ca:| Value of the ca| Provided in the repo |
| crt:| Value of the crt| Provided in the repo |
| key:| Value of the key| Provided in the repo |
| gwService:| All Values reg Gateway Service| - |
| name:| Name of the Gateway Service| apic-dp-gw-service |
| commonName:| CommonName for the Gateway Service| apic-dp-gw-service |
| issuerName:| IssuerName for the Gateway Service| apic-dp-ingress |
| gwPeering:| All Values reg Gateway Peering| - |
| name:| Name of the Gateway Peering| apic-dp-gw-service |
| commonName:| CommonName for the Gateway Peering| apic-dp-gw-service |
| secretName:| SecretName for the Gateway Peering| apic-dp-gw-service |
| issuerName:| IssuerName for the Gateway Peering| apic-dp-ingress |
| gatewaycluster:| Gateway Cluster Details| Example Values |
| name:| Name of the Gateway Cluster| apic-dp-gw-tp |
| version:| Version| 10.0.5.4 |
| profile:| Profile that we want to use for deployment| n1xc1.m8 |
| gatewayEndpointIssuer:| Name of the gateway endpoint issuer| ingress-issuer |
| gatewayEndpointHostname:| Name of the gateway endpoint Hostname| apicdp-gtw-tp-custview-back.sgtech.gs.corp |
| gatewayEndpointSecret:| Name of the Gateway Endpoint Secret| certificate-dns-gtw-tp |
| gatewayManagerIssuer| Name of the gateway manager Issuer| ingress-issuer |
| gatewayManagerEndpointHostname:| Name of the Gateway Manager Endpoint Hostname| apicdp-gtw-mng-tp-custview-back-cn1.sgtech.gs.corp |
| gatewayManagerEndpointSecret:| Name of the Gateway Manager Endpoint Secret| certificate-dns-gtw-mng-tp |
| apicGatewayServiceTlsSecret:| Name of the Gateway Service Secret| apic-dp-gw-service |
| apicGatewayPeeringTlsSecret:| Name of the gateway Peering issuer (error)| apic-dp-gw-peering |
| license:| Value varies for nonprod and prod, for example this is for prod| L-VQYA-YNM22H |
| use:| Env Value: Production or NonProduction| production |
| adminUserSecret:|Name of the variable where admin user secret is stored | admin-credentials |
| resources: limits:| - | - |
| limitMemory:| Memory Limit that we want to allocate | 4Gi |
| limitCpu:| CPU limit we want to allocate | 1 |
| requests: requestMemory:| Value of the memory that can be requested| 4Gi |
| requestCpu:| Value of the CPU that can be requested| 500m |
| webGUIManagementEnabled:| To enable web management for new Domains| true |
| webGUIManagementPort:| Once webmanagement is enabled, port to access the UI| 9090 |<br>

##### Configuration File -  routes.yaml to create route to access UI

``` yaml
    \{\{- if eq (toString .Values.gatewaycluster.webGUIManagementEnabled) "true" \}\}
    kind: Route
    apiVersion: route.openshift.io/v1
    metadata:
        name: \{\{ .Values.route.name \}\}
    spec:
        to:
            kind: Service
            name: \{\{ .Values.gatewaycluster.name \}\}-datapower
        port:
           targetPort: webgui-port
        tls:
            termination: passthrough
            insecureEdgeTerminationPolicy: None
        wildcardPolicy: None
    \{\{- end \}\}
```

##### Configuration File - gatewaycluster.yaml - Additional Parameters

Parameters to be modified for customization for Domains:

- AdditionalExtraExe:

The extraExe property is an array of strings that represent name(s) of ConfigMaps in the cluster. When the DataPower pod(s) are created, the ConfigMaps specified by extraExe are mounted with r+x permissions at /usr/local/extra.

Example:

```yaml
additionalExtraExe:
  - copy-files
```

[Reference Documentation](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=s-extraexe-1)

- AdditionalInitCmds:

       The initCmds property is an array of strings that represent initialization commands that you wish to run prior to the DataPower process starting. These commands will be run after the DataPower Operator internal initialization scripts, but before the DataPower start.sh script. 

Example:

```yaml
additionalInitCmds:
  - /usr/local/extra/copy-files.sh
```

[Reference Documentation](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=s-initcmds-1)

- AdditionalDomainConfig:
    The domains property allows for user-provided domain configuration(s) to be injected into the DataPower pods at runtime, prior to the DataPower process starting.
    This configuration allows to deploy multiple domains for use. To deploy multiple domains here is the config file:

For example, if we want to create two new domains here with name apiconnect1 and apiconnect2, here is the format:

```yaml
additionalDomainConfig:
  - name: "apiconnect1"
    certs:
      - certType: “certs”
        secret: “scert”
    dpApp:
      config:
        - “sbna-apiconnect-cfg”
  - name: “apiconnect2"
    dpApp:
      local:
      - “apic-local”
      config:
      - “sbna-apic-cfg”
```

[Reference Documentation](https://www.ibm.com/docs/en/datapower-operator/1.6?topic=s-domains-1)

The domains property allows for user-provided domain configurations to be injected into datapower pods at runtime, prior to the datapower process starting.

Each domains entry can consist of the following fields:

```yaml
   - name
       Name of the Domain.

   - certs
       Certs can be a list of certificate:
          - certType
             cert type with usrcerts will be available only to this domain
             cert type with sharedcerts will be available to all domain
          - secret
             Name of OCP secret containing the secret file.

        Format:
           - name: “apiconnect”
             certs:
               - certType: “usrcerts”
               - secret: “cert-sbna”
    - dpApp
Basic abstraction of a domain's configuration and local files using ConfigMaps.

Consist of 2 arrays:
- config
- local

    Format:
                        - name:  “apiconnect”
                           dpApp:  
                               local:
                               -  “sbna-local”
                               config:
                               -  “sbna-cfg”  


    - passphrase
Controls the domain settings passphrase and supports both user provided and generated values

          Passphrase object are two properties:
- secret A user provided secret name
- generate Boolean value, if true will generate a value for passphrase

         Format:
                 spec:                                                                                                                spec:
                    domains:                                                                                                           domains:  
                    - name: default                                                                                                    -name: default
                       settings:                                                                                                          settings:
                            passphrase:                                                                                                      passphrase:
                                   secret: default-passphrase                                                                                   generate: true
```

##### Build and Deploy your Datapower Gateway

We will now describe the steps you need to take in order to be able to deploy your Datapower Gateway through the DEV, PRE and PRO environments.

To deploy follow the steps below:

- Create your workflow as described below, this will deploy and publish the helm chart
- Provide the values like chart name, cluster name and repo name.
- Configure the credentials to deploy the code in OCP. This needs to be done on the github.
- Push the code in to the github repository.
- Use the workflow to deploy the code
- Deploy the code from Github actions.
- From the Actions tab, select the workflow openshift-helm-chart-ci-workflow.yml.
- On the right side of the screen, click on Run workflow.
- And finally, select the branch where we have the deployment configuration and click on Run workflow as    shown.

- Example:

![Example Build and Deploy Datapower Gateway](../assets/images/build-deploy-datapower.png){: .image-popup align="center" style="width:80%"}

**Below are the steps that is done by the github action pipeline:**

- Set up the environment

- helm list ; helm publish ; deploy ; validate the push

- It will add new domains and add configuration to the existing one if there are changes.

![Example Build and Deploy Datapower Gateway](../assets/images/build-deploy-datapower2.png){: .image-popup align="center" style="width:80%"}

##### Validating DataPower Gateway deployment

- To validate the deployment, check the statefulsets.
- Getting password to Login
- Under Workloads > Secrets > Click on “admin-credentials” that was specified in the template.

![Validating Datapower Deployment](../assets/images/validation-datapower-deployment.png){: .image-popup align="center" style="width:60%"}

- Getting the URL to login.

- Login into OCP cluster > Networking >  Routes > Datapower Domain

![Validating Datapower Deployment Step 2](../assets/images/validation-datapower-deployment2.png){: .image-popup align="center" style="width:80%"}

- Login into the site using the credentials and verify.
- Username: admin
- Password:  the one we got from secrets
- Domain: the domain that we deployed

![Validating Datapower Deployment Step 2](../assets/images/validation-datapower-deployment3.png){: .image-popup align="center" style="width:40%"}

- You should be able to see the page like this with the domain that you deployed.

![Validating Datapower Deployment Step 2](../assets/images/validation-datapower-deployment4.png){: .image-popup align="center" style="width:70%"}

#### Backup and Disaster Recovery

- API Connect Management is needed to be backed-up
- API Connect Datapower do not need to be back up . In case of disaster recovery, being a stateless component, the strategy is to redeploy it.
When deploying from github sources it will be synchronized with the manager and with Kubernetes configmaps and secrets recovering its full functionality.

## Policies development strategy

IBM recommends prioritizing the use of built-in policies. If it is necessary to implement a more complex policy, IBM recommends to combine the built-in policies with logic constructors.

Please review the following link for further information of built-in policies: [Built-in policies](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=constructs-built-in-policies)

In case additional functionality is required IBM recommends the use of User-Defined Policies. [User-Defined policies](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=constructs-user-defined-policies)

Operational PaaS establishes the following guidelines for the use of User-Defined Policies:

- Prioritize the use of IBM built-in policies (DataPower Api Gateway v10 native) when possible, except Gatewayscript.
- Prioritize the use of the combination of built-in policies with logic constructors over IBM Libraries.
- No external libraries out of IBM framework are allowed.If a user-defined policy must be configured by operation, it must be designed using an operation-switch.
- Policies must not use static files in the DataPower for Api & Policies Configurations
- Policies must replace variable values in CI/CD deployment flows.
- The use of extensions should be reduced to the minimum necessary.

Following this strategy it is only required one step to deploy in api connect. Notice that policies are deployed in gateway level.

The command according to the official IBM documentation would be as follows: apic policies:create [flags] POLICY_FILE<br>
A real example in an Api Connect Installation 10.0.5 LTS:<br>
 Prerequirements:login has previously done

```bash
./apic policies:create --server https://apicgl-apim.sgtech.gs.corp --org gluon-paas --scope catalog --catalog intranet-touchpoints-customer-overview --configured-gateway-service intranet-cn2-sgt-gluon-tp-poc-cview-bk-pro-tp jwsid-generate.zip
```

![IBM API Connect Policy Deployment](../assets/images/api-connect-policy-create-example.png){: .image-popup align="center" style="width:70%"}<br>

[Official Documentation Command Link](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=policies-apic-policiescreate)

## Apis & Products Deployment

The deployment procedure for APIs and products, once the strategy of simplification in the configuration of policies and deployment artifacts has been followed, will be identical for deployments in IaaS or Kubernetes.
In summary, it will only be necessary to handle one artifact for the deployment of an API and in the same way for the product. The high-level procedure will be the one shown in the following figure:

![IBM API Connect v10 API Deployment - High level view](../assets/images/api-connect-high-level.png){: .image-popup align="center" style="width:70%"}<br>

This procedure includes commands from the IBM Api Connect Toolkit. You can find more info about the use of this CLI , in the home section of any manager install. Or in the official documentation: [Official Documentation IBM Api Connect Toolkit](https://www.ibm.com/docs/SSMNED_10.0.5/com.ibm.apic.toolkit.doc/capim_cli_working_with.html)<br>
The first step to use this cli is to login in the api platform to do that the command is:

```bash
./apic login --username username@gruposantander.com --password password --server https://apicgl-apim.sgtech.gs.corp --realm provider/default-idp-2
```

The steps to carry out a complete deployment would be as follows:

- 0: API Definition: The first step is to have available an API Definition in order to build the artifact based on it and execute the deployment after that.

- 1: Environment info : All data that depend on the environment where the deployment is going to be done, must be available to be included in the Api Deployment artifact.
To be included in the deployment artifact, as shown in the image.

![API Example Configuration](../assets/images/api-connect-trailinfo-example.png){: .image-popup align="center" style="width:50%"}<br>

- 2: API Configuration :  In this step, all the configuration related to the Api, its operations, and policy settings should be prepared.
This configuration will be configured agnostically to the Api technology.

![API Example Configuration](../assets/images/api-connect-api-example.png){: .image-popup align="center" style="width:80%"}<br>

- 3: API Deployment Artifact : With the two previous steps correctly executed, it is possible to execute the creation of the Api Deployment component.
This component is based on different templates depending on the exposure profile and on the substitution of the appropriate variables with the information previously reported in the two previous steps.
The artifact generated is the one that will be used along with the Api Product to make the final publication.

```yaml
 openapi: 3.0.0
info:
  title: Touchpoint API
  version: 1.2.0
  description: >-
    Provides information about contracts and balances of a customer. It also
    includes endpoints to allow sorting the sequence of each product family in
    the list.
  x-santander-catalogation:
    bian-landscape-version: '11'
    bian-business-area: Sales and Services
    bian-business-domain: Customer Management
    bian-service-domain: Customer Products and Services
  contact:
    name: Name and Last name
    email: name.lastName@gruposantander.com
  license:
    name: Apache
    url: https://www.apache.org/licenses/LICENSE-2.0
  x-ibm-name: customer-position-mock
servers:
  - url: /v2/customer_pos
security:
  - clientID: []
x-ibm-configuration:
  properties:
    target-url:
      value: http://example.com/operation-name
      description: The URL of the target service
      encoded: false
  cors:
    enabled: true
  gateway: datapower-api-gateway
  type: rest
  phase: realized
  enforced: true
  testable: true
  assembly:
    execute:
      - jwsid-generate:
          version: 1.2.1
          title: jwsid-generate
          user: user
          exp: 60000
          aud: customer_products_and_services
      - invoke:
          version: 2.2.0
          title: invoke
          backend-type: detect
          header-control:
            type: blocklist
            values: []
          parameter-control:
            type: blocklist
            values: []
          http-version: HTTP/1.1
          timeout: 60
          verb: keep
          chunked-uploads: true
          persistent-connection: true
          cache-response: protocol
          cache-ttl: 900
          stop-on-error: []
          graphql-send-type: detect
          websocket-upgrade: false
          target-url: >-
            https://sgt-gluon-touchpoints-poc-customerview-back-dev.apps.sgt01.sgt.dev.cn1.paas.cloudcenter.corp/sgt-touchgp-glnpaaspersi/customer-position
    finally: []
  activity-log:
    enabled: true
    success-content: activity
    error-content: payload
tags:
  - name: Customer position
    description: Customer position
paths:
  /:
    get:
      description: >-
        Provides a customer's total balances for each group of product
        families.
         Provides the detailed balances of each customer contract.
         It performs grouping of balances by product and family of products.
      operationId: getCustomerPosition
      tags:
        - Customer position
      responses:
        '200':
          $ref: '#/components/responses/Get200_GlobalPosition'
        '204':
          $ref: '#/components/responses/NoContent'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '404':
          $ref: '#/components/responses/NotFound'
        '415':
          $ref: '#/components/responses/UnsupportedMediaType'
        '500':
          $ref: '#/components/responses/InternalServerError'
        '503':
          $ref: '#/components/responses/ServiceUnavailable'
        '504':
          $ref: '#/components/responses/GatewayTimeout'
      parameters:
        - $ref: '#/components/parameters/authorization'
        - $ref: '#/components/parameters/accept-language'
        - $ref: '#/components/parameters/device-information'
        - $ref: '#/components/parameters/content-type'
        - $ref: '#/components/parameters/accept'
        - $ref: '#/components/parameters/product_family'
        - $ref: '#/components/parameters/active_only'
        - $ref: '#/components/parameters/operation'
        - $ref: '#/components/parameters/profile_id'
        - $ref: '#/components/parameters/customer_id'
components:
  schemas:
    _AccountsMonthlyBalanceResponseDTO:
      description: >-
        Data structure containing all the information related to the customer
        position view.
      type: object
      properties:
        accountsMonthlyBalance:
          description: list containing the monthly balances
          type: array
          items:
            $ref: '#/components/schemas/_AccountMonthlyBalanceItem'
    _AccountMonthlyBalanceItem:
      description: >-
        Data structure containing all the information related to the customer
        position view.
      type: object
      properties:
        account:
          $ref: '#/components/schemas/_AccountMonthlyBalance'
        monthlyBalance:
          description: monthly balance for the account specified in the 'account' parameter
          type: array
          items:
            $ref: '#/components/schemas/_MonthlyBalanceItem'
    _MonthlyBalanceItem:
      description: Monthly balance
      type: object
      properties:
        month:
          $ref: '#/components/schemas/Order'
        balance:
          $ref: '#/components/schemas/Amount'
        expense:
          $ref: '#/components/schemas/Amount'
        income:
          $ref: '#/components/schemas/Amount'
    _AccountMonthlyBalance:
      x-bizObjRef: Account
      type: object
      description: Data structure containing account information
      properties:
        accountId:
          description: Unique account ID
          type: string
          example: '00491655300123456700'
    _GetGlobalPositionResponse:
      description: >-
        Data structure containing all the information related to the customer
        position.
      type: object
      properties:
        accounts:
          $ref: '#/components/schemas/_AccountsInformation'
        cards:
          $ref: '#/components/schemas/_CardsInformation'
        loans:
          $ref: '#/components/schemas/_LoansInformation'
        deposits:
          $ref: '#/components/schemas/_DepositsInformation'
        pensions:
          $ref: '#/components/schemas/_PensionsInformation'
        securities:
          $ref: '#/components/schemas/_SecuritiesInformation'
        investmentFunds:
          $ref: '#/components/schemas/_InvestmentFundsInformation'
        investmentsInsurances:
          $ref: '#/components/schemas/_InsuranceInformation'
        savingsInsurances:
          $ref: '#/components/schemas/_InsuranceInformation'
        managedPortfolios:
          $ref: '#/components/schemas/_PortfoliosInformation'
        unmanagedPortfolios:
          $ref: '#/components/schemas/_PortfoliosInformation'
        unitLinked:
          $ref: '#/components/schemas/_UnitLinkedInformation'
    _InsuranceInformation:
      description: >-
        Data structure containing aggregated information from the Insurance
        balances and broken down to Insurance level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_InsuranceTotalBalances'
        list:
          description: Array of investments.
          type: array
          items:
            $ref: '#/components/schemas/_InsuranceWithLinks'
    _InsuranceWithLinks:
      type: object
      description: Data structure containing Insurance information and interest links.
      properties:
        insurance:
          $ref: '#/components/schemas/InsurancePolicy'
    _InsuranceTotalBalances:
      description: >-
        Data structure containing aggregated information from the investment
        balances.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
    _PortfoliosInformation:
      description: >-
        Data structure containing aggregated information from the Insurance
        balances and broken down to Insurance level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_PortfoliosTotalBalances'
        list:
          description: Array of Portfolios.
          type: array
          items:
            $ref: '#/components/schemas/_PortfoliosWithLinks'
    _PortfoliosWithLinks:
      type: object
      description: Data structure containing Portfolio information and interest links.
      properties:
        portfolios:
          $ref: '#/components/schemas/InvestmentPortfolio'
    _PortfoliosTotalBalances:
      description: Data structure containing aggregated information from portfolios.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
    _AccountsInformation:
      description: >-
        Data structure containing aggregated information from the account
        balances and broken down to account level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_AccountTotalBalances'
        list:
          description: Array of accounts.
          type: array
          items:
            $ref: '#/components/schemas/_AccountWithLinks'
    _AccountWithLinks:
      type: object
      description: Data structure containing account information and interest links.
      properties:
        account:
          $ref: '#/components/schemas/Account'
        bank:
          $ref: '#/components/schemas/Bank'
    _AccountTotalBalances:
      description: >-
        Data structure containing aggregated information from the account
        balances.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
        totalWithholding:
          $ref: '#/components/schemas/Amount'
        totalAvailable:
          $ref: '#/components/schemas/Amount'
    _CardsInformation:
      description: Data structure containing information broken down to card level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        list:
          description: Array of cards.
          type: array
          items:
            $ref: '#/components/schemas/_CardWithLinks'
    _CardWithLinks:
      type: object
      description: Data structure containing card information and interest links.
      properties:
        card:
          $ref: '#/components/schemas/Card'
        bank:
          $ref: '#/components/schemas/Bank'
    _LoansInformation:
      description: >-
        Data structure containing aggregated information from the loan balances
        and broken down to account level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_LoanTotalBalances'
        list:
          description: Array of loans.
          type: array
          items:
            $ref: '#/components/schemas/_LoanWithLinks'
    _LoanWithLinks:
      type: object
      description: Data structure containing loan information and interest links.
      properties:
        loan:
          $ref: '#/components/schemas/Loan'
        bank:
          $ref: '#/components/schemas/Bank'
    _LoanTotalBalances:
      description: Data structure containing aggregated information from the loan balances.
      type: object
      properties:
        totalPrincipal:
          $ref: '#/components/schemas/Amount'
        totalAmortization:
          $ref: '#/components/schemas/Amount'
    _DepositsInformation:
      description: >-
        Data structure containing aggregated information from the deposit
        balances and broken down to deposit level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_DepositTotalBalances'
        list:
          description: Array of deposits.
          type: array
          items:
            $ref: '#/components/schemas/_DepositWithLinks'
    _DepositWithLinks:
      type: object
      description: Data structure containing deposit information and interest links.
      properties:
        deposit:
          $ref: '#/components/schemas/Deposit'
        balances:
          $ref: '#/components/schemas/Balances'
        bank:
          $ref: '#/components/schemas/Bank'
    _DepositTotalBalances:
      description: >-
        Data structure containing aggregated information from the deposit
        balances.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
        totalProfit:
          $ref: '#/components/schemas/Amount'
    _PensionsInformation:
      description: >-
        Data structure containing aggregated information from the pension plan
        balances and broken down to pension plan level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_PensionTotalBalances'
        list:
          description: Array of pension plans.
          type: array
          items:
            $ref: '#/components/schemas/_PensionWithLinks'
    _PensionWithLinks:
      type: object
      description: Data structure containing pension plan information and interest links.
      properties:
        pension:
          $ref: '#/components/schemas/InvestmentPensionContract'
        bank:
          $ref: '#/components/schemas/Bank'
    _PensionTotalBalances:
      description: >-
        Data structure containing aggregated information from the pension plan
        balances.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
    _SecuritiesInformation:
      description: >-
        Data structure containing aggregated information from the security
        balances and broken down to security level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_SecurityTotalBalances'
        list:
          description: Array of securities.
          type: array
          items:
            $ref: '#/components/schemas/_SecurityWithLinks'
    _SecurityWithLinks:
      type: object
      description: Data structure containing security information and interest links.
      properties:
        security:
          $ref: '#/components/schemas/InvestmentShareContract'
        bank:
          $ref: '#/components/schemas/Bank'
    _SecurityTotalBalances:
      description: >-
        Data structure containing aggregated information from the security
        balances.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
    _InvestmentFundsInformation:
      description: >-
        Data structure containing aggregated information from the investment
        balances and broken down to investment level.
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_InvestmentFundTotalBalances'
        list:
          description: Array of investments.
          type: array
          items:
            $ref: '#/components/schemas/_InvestmentFundWithLinks'
    _InvestmentFundWithLinks:
      type: object
      description: Data structure containing investment information and interest links.
      properties:
        investmentFund:
          $ref: '#/components/schemas/InvestmentFundContract'
        bank:
          $ref: '#/components/schemas/Bank'
    _InvestmentFundTotalBalances:
      description: >-
        Data structure containing aggregated information from the investment
        balances.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
    _UnitLinkedInformation:
      description: Data structure containing data about the unit-linked plan product family
      type: object
      properties:
        viewConfiguration:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        totalBalances:
          $ref: '#/components/schemas/_UnitLinkedTotalBalances'
        list:
          description: Array of accounts.
          type: array
          items:
            $ref: '#/components/schemas/_UnitLinkedLinks'
    _UnitLinkedTotalBalances:
      description: >-
        Data structure containing aggregated information from the account
        balances.
      type: object
      properties:
        totalCurrent:
          $ref: '#/components/schemas/Amount'
    _UnitLinkedLinks:
      type: object
      description: Data structure containing account information and interest links.
      properties:
        unitLinked:
          $ref: '#/components/schemas/UnitLinked'
    Account:
      type: object
      description: Data structure containing account information
      properties:
        accountId:
          description: Unique account ID
          type: string
          example: '9012781018079'
        accountIdentification:
          description: >-
            Data structure containing information related to account
            identification
          type: object
          properties:
            internationalIdentification:
              type: string
              description: International Bank Account Number (IBAN) obfuscated.
              example: ES91xxxxxxxxxxxx0051332
            nationalIdentification:
              type: string
              description: National bank account number obfuscated.
              example: 9021xxxxxxxx676767
        typeCode:
          description: Account type code
          type: string
          example: '10'
        typeDescription:
          description: Account type description
          type: string
          example: Saving
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: MY CHECKING ACCOUNT
            isMainItem:
              type: boolean
              description: >-
                Whether the item is the customer's main item. Applies only when
                the operation is used by a physical or business customer, not
                when used by Santander staff.


                The possible values are:

                - true = Main item

                - false = Secondary item
              example: true
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
        balances:
          $ref: '#/components/schemas/Balances'
    Card:
      type: object
      description: Data structure containing card details
      properties:
        cardId:
          type: string
          description: >-
            Card ID that is used to uniquely identify the card in card-related
            operations. For internal use, the value does not require
            tokenization.
          example: '4547420008209985'
        cardIdentification:
          description: Data structure containing identification information for a card
          type: object
          properties:
            displayNumber:
              description: Displayed card number
              type: string
              example: xxxx-xxxx-xxxx-5643
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: Card for family expenses
            isMainItem:
              type: boolean
              description: >-
                Whether the item is the customer's main item. Applies only when
                the operation is used by a physical or business customer, not
                when used by Santander staff.


                The possible values are:

                - true = Main item

                - false = Secondary item
              example: true
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        type:
          type: string
          description: Card type that defines the operations for which it can be used
          example: CREDIT CARD
        typeCode:
          description: Card type code
          type: string
          example: '01'
        typeDescription:
          description: Card type description
          type: string
          example: Visa Oro 123
        statusInfo:
          description: Data structure containing information about the status of an item
          type: object
          properties:
            statusCode:
              type: string
              description: Status code
              example: CANC
            statusDescription:
              type: string
              description: Status description
              example: INACTIVE
            statusReasonCode:
              type: string
              description: Status reason code
              example: DQUA
            statusReasonDescription:
              type: string
              description: Description of the status reason
              example: Stolen
        balances:
          $ref: '#/components/schemas/Balances'
    Loan:
      description: Data structure containing information about a loan
      type: object
      properties:
        loanId:
          type: string
          description: Unique loan ID
          example: '1520891037864384'
        loanIdentification:
          description: Data structure containing information to identify a loan
          type: object
          properties:
            nationalIdentification:
              type: string
              description: National loan identification
              example: '091520891037864384'
            internalIdentification:
              description: Internal loan identification
              type: string
              example: '031700015000501323'
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: MY LOAN ACCOUNT
            isMainItem:
              type: boolean
              description: >-
                Whether the item is the customer's main item. Applies only when
                the operation is used by a physical or business customer, not
                when used by Santander staff.


                The possible values are:

                - true = Main item

                - false = Secondary item
              example: true
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
        balances:
          $ref: '#/components/schemas/Balances'
        nextPaymentAmount:
          $ref: '#/components/schemas/Amount'
    Deposit:
      description: Data structure containing information about a deposit
      type: object
      properties:
        depositId:
          type: string
          description: Unique deposit ID
          example: '1520893020013689'
        depositIdentification:
          description: Data structure containing identification information for a deposit
          type: object
          properties:
            nationalIdentification:
              type: string
              description: National bank deposit number
              example: '902127899967676767'
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
            validityPeriod:
              type: object
              description: Data structure containing period information
              properties:
                endDate:
                  type: string
                  description: |-
                    Date when the period ends.

                    The value uses the complete data format defined in ISO 8601:

                    'YYYY-MM-DD'

                    Where:
                    - YYYY: 4-digit year
                    - MM: 2-digit month (for example, 01 = January)
                    - DD: 2-digit day of the month (01 through 31)
                  format: date
                  example: '2025-12-01'
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: MY DEPOSIT ACCOUNT
            isMainItem:
              type: boolean
              description: >-
                Whether the item is the customer's main item. Applies only when
                the operation is used by a physical or business customer, not
                when used by Santander staff.


                The possible values are:

                - true = Main item

                - false = Secondary item
              example: true
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
    InvestmentPensionContract:
      description: Data structure containing information about a pension plan
      type: object
      properties:
        investmentPensionContractId:
          type: string
          description: Unique pension plan ID
          example: '1578653139876456'
        pensionIdentification:
          description: >-
            Data structure containing identification information for a pension
            plan
          type: object
          properties:
            displayNumber:
              description: Displayed pension plan number
              type: string
              example: 00***384
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: MY PENSION ACCOUNT
            isMainItem:
              type: boolean
              description: >-
                Whether the item is the customer's main item. Applies only when
                the operation is used by a physical or business customer, not
                when used by Santander staff.


                The possible values are:

                - true = Main item

                - false = Secondary item
              example: true
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
        balances:
          $ref: '#/components/schemas/Balances'
    InsurancePolicy:
      type: object
      description: Data structure containing information about an insurance policy
      properties:
        insurancePolicyId:
          type: string
          description: Unique insurance policy ID
          example: '001520893020013689'
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: Family Insurance
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        insuranceIdentification:
          description: >-
            Data structure containing identification information for an
            insurance policy
          type: object
          properties:
            policyNumber:
              description: Insurance policy number obfuscated
              type: string
              example: xxxxxxxx90987654321
        contract:
          type: object
          description: Data structure containing contract information
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        premiumAmount:
          $ref: '#/components/schemas/Amount'
    InvestmentPortfolio:
      type: object
      description: Data structure containing information about an investment portfolio
      properties:
        portfolioId:
          type: string
          description: Unique portfolio ID
          example: invpor123456
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: Portfolio
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        portfolioIdentification:
          description: >-
            Data structure containing identification information for an
            insurance policy
          type: object
          properties:
            portfolioNumber:
              description: Portfolio number
              type: string
              example: '1234567890987654321'
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
        balances:
          $ref: '#/components/schemas/Balances'
    InvestmentShareContract:
      type: object
      description: >-
        Data structure containing information about an investment share
        contract. A trader must have an investment share contract in place for
        each company whose shares they intend to trade.
      properties:
        investmentShareContractId:
          description: Unique ID for the investment share contract
          type: string
          example: Sales0123456789
        investmentShareIdentification:
          description: >-
            Data structure containing identification information for an
            investment share
          type: object
          properties:
            displayNumber:
              description: Displayed investment share number
              type: string
              example: '001578658029699345'
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: MY SECURITY ACCOUNT
            isMainItem:
              type: boolean
              description: >-
                Whether the item is the customer's main item. Applies only when
                the operation is used by a physical or business customer, not
                when used by Santander staff.


                The possible values are:

                - true = Main item

                - false = Secondary item
              example: true
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
        balances:
          $ref: '#/components/schemas/Balances'
    InvestmentFundContract:
      description: Data structure containing information about an investment fund contract
      type: object
      properties:
        investmentFundContractId:
          type: string
          description: Investment fund contract ID
          example: '1578658029699345'
        investmentFundIdentification:
          description: >-
            Data structure containing identification information for an
            investment fund
          type: object
          properties:
            displayNumber:
              description: Displayed investment fund number
              type: string
              example: '001578658029699345'
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        channelAccessAgreementInformation:
          description: Data structure containing information about a customer overview item
          type: object
          properties:
            alias:
              type: string
              description: >-
                Name (alias) that the customer has assigned to the item for easy
                identification. Only required for customer usability.
              example: MY INVESTMENT FUND ACCOUNT
            isMainItem:
              type: boolean
              description: >-
                Whether the item is the customer's main item. Applies only when
                the operation is used by a physical or business customer, not
                when used by Santander staff.


                The possible values are:

                - true = Main item

                - false = Secondary item
              example: true
            presentationOrder:
              type: integer
              description: >-
                Display order of the contract within the product family-specific
                list.


                The possible values are incremental whole digits from 0:

                - All contracts with 0 are listed first, using an internal
                contract ID to determine their mutual order

                - Contracts with 1, 2... are listed next in the order defined

                - Any contracts with no defined display order are listed at the
                end, using an internal contract ID to determine their mutual
                order


                The default value is 0.
              example: 1
            isVisible:
              type: boolean
              description: |-
                Contract visibility indicator.

                The possible values are:
                - true = Contract is shown in the customer's global position
                - false = Contract is hidden in the customer's global position

                The default value is true.
              example: true
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
        balances:
          $ref: '#/components/schemas/Balances'
    Balances:
      description: Array of balances
      type: array
      items:
        $ref: '#/components/schemas/Balance'
    Balance:
      type: object
      description: >-
        Data structure containing a numerical representation of the net
        increases and decreases in an account at a specific point in time
      properties:
        amount:
          $ref: '#/components/schemas/Amount'
        typeCode:
          type: string
          description: Balance type code
          example: CRRT
        typeDescription:
          type: string
          description: Balance type description
          example: Current
        lastUpdateDate:
          type: string
          format: date
          description: |-
            Date when the balance was last updated.

            The value uses the complete data format defined in ISO 8601:

            'YYYY-MM-DD'

            Where:
            - YYYY: 4-digit year
            - MM: 2-digit month (for example, 01 = January)
            - DD: 2-digit day of the month (01 through 31)
          example: '2020-12-01'
    StatusInfo:
      description: Data structure containing information about the status of an item
      type: object
      properties:
        statusDescription:
          type: string
          description: Status description
          example: ACTIVE
    Amount:
      description: Data structure containing amount details
      type: object
      properties:
        amount:
          description: >-
            Amount.


            The value uses the data format defined in ISO 20022 and has a
            maximum of 18 digits, of which 5 can be decimals, separated by a
            point.
          type: number
          example: 99.99
        currency:
          description: >-
            Currency code.


            The value is in the alpha-3 format defined in ISO 4217
            (https://www.iso.org/iso-4217-currency-codes.html).
          type: string
          minLength: 3
          maxLength: 3
          pattern: (^.{3}$)
          example: EUR
    Order:
      type: integer
      description: Order
      example: 1
    ChannelAccessAgreementInformation:
      description: Data structure containing information about a customer overview item
      type: object
      properties:
        presentationOrder:
          type: integer
          description: >-
            Display order of the contract within the product family-specific
            list.


            The possible values are incremental whole digits from 0:

            - All contracts with 0 are listed first, using an internal contract
            ID to determine their mutual order

            - Contracts with 1, 2... are listed next in the order defined

            - Any contracts with no defined display order are listed at the end,
            using an internal contract ID to determine their mutual order


            The default value is 0.
          example: 1
        isVisible:
          type: boolean
          description: |-
            Contract visibility indicator.

            The possible values are:
            - true = Contract is shown in the customer's global position
            - false = Contract is hidden in the customer's global position

            The default value is true.
          example: true
    Bank:
      description: Data structure containing bank details
      type: object
      properties:
        bankId:
          description: Unique bank ID
          example: AAOZ
          type: string
    UnitLinked:
      description: Data structure containing information about a unit-linked plan
      type: object
      properties:
        unitLinkeddId:
          type: string
          description: Unit-linked plan ID
          example: '001578653066574321'
        unitLinkedIdentification:
          $ref: '#/components/schemas/UnitLinkedIdentification'
        contract:
          description: Data structure containing contract information
          type: object
          properties:
            product:
              type: object
              description: >-
                Data structure containing product information. Products can be
                services or goods.
              properties:
                productCode:
                  type: string
                  description: Product code
                  example: '0049300130'
                productDescription:
                  type: string
                  description: Product description
                  example: Santander Checking Account
        channelAccessAgreementInformation:
          $ref: '#/components/schemas/ChannelAccessAgreementInformation'
        statusInfo:
          $ref: '#/components/schemas/StatusInfo'
        balances:
          $ref: '#/components/schemas/Balances'
    UnitLinkedIdentification:
      description: >-
        Data structure containing identification information for a unit-linked
        plan
      type: object
      properties:
        displayNumber:
          description: Displayed unit-linked plan number
          type: string
          example: '001578653066574321'
    Errors:
      type: object
      description: Data structure containing the details for errors
      properties:
        errors:
          description: Array of errors
          type: array
          items:
            $ref: '#/components/schemas/Error'
    Error:
      type: object
      description: Data structure containing the error details
      properties:
        code:
          type: string
          description: Unique alphanumeric human readable error code
          example: ERR001
        message:
          type: string
          description: Brief summary of the reported issue
          example: Invalid Action
        level:
          type: string
          description: Level of the reported issue
          enum:
            - info
            - warning
            - error
          example: error
        description:
          type: string
          description: Detailed description of the reported issue
          example: Description
  parameters:
    authorization:
      name: authorization
      schema:
        type: string
      required: false
      in: header
      description: Field to send the access token to the API, initially OAuth and JWT.
    language:
      name: language
      schema:
        type: string
      required: false
      in: header
      description: >-
        The server responds with the field in the header with the response
        language. Following the ([ISO 639-2]-[ISO 3166-1/Alpha3]) code standard.
      x-example: Spain will be es-ESP
    accept-language:
      name: accept-language
      schema:
        type: string
      required: false
      in: header
      description: >-
        The consumer list of languages by order of preference. Following the
        (([ISO 639-2]-[ISO 3166-1/Alpha3])) code standard.
      x-example: Spain will be es-ESP
    device-information:
      name: device-information
      schema:
        type: string
      required: false
      in: header
      description: >-
        CHANNEL/SEGMENT FRONT_APP/VERSION DEVICE OS/OS_VERSION
        NETWORK_CLIENT/VERSION FRAMEWORK/VERSION Channel: [ISO 639-2][] plus 5
        custom country digits. For Segment: retail / business Front_App/Version:
        For example OneApp/1.0 Device: Platform value extracted from the device.
        For example iPhone13 OS/VERSION: android / iOS / windows / linux /
        macOS, version is a platform value extracted from the device. For
        example iOS/1.0 Network_Client/Version: App network client and version.
        For example CF_Network/5.1 Framework/Version: For example Darwin/16.3.0
    content-type:
      name: content-type
      schema:
        type: string
      required: false
      in: header
      description: >-
        The server responds with the data format of the response. Backend
        expected a JSON document format.
      x-example: application/json
    accept:
      name: accept
      schema:
        type: string
      required: false
      in: header
      description: >-
        The consumer request the data format of the response by order of
        preference.Backend expected a JSON document format.
      x-example: application/json
    product_family:
      name: product_family
      in: query
      required: false
      schema:
        type: string
      description: >-
        The family to which a product belongs. A product can only belong to a
        single family.  Available values (accounts, cards, loans, deposits and
        securities)
      x-example: cards
    active_only:
      name: activeOnly
      in: query
      required: true
      schema:
        type: boolean
      description: Whether return only contracts active.
      x-example: true
    operation:
      name: operation
      schema:
        type: string
        enum:
          - contracts
          - transferFrom
          - transferTo
          - makePayment
      in: query
      description: Operation value that need to be considered for filter
      required: false
    profile_id:
      name: profile_id
      schema:
        type: string
      required: false
      in: query
      description: >-
        Unique ID for the user profile (if not indicated, use the default for
        the client) .
      x-example: '123456789'
    customer_id:
      name: customer_id
      schema:
        type: string
      required: false
      in: query
      description: Customer ID
      x-example: F1234567
    bank_id:
      name: bank_id
      schema:
        type: string
      required: false
      in: query
      description: Unique bank ID
      x-example: AAOZ
    refresh:
      name: refresh
      in: query
      required: false
      schema:
        type: boolean
      description: >-
        If true performs a manual update of the global position information of
        one particular user bank.
      x-example: false
    from_month:
      name: from_month
      schema:
        type: string
      required: true
      in: path
      description: >-
        Date with the format MMYYYY to set the initial date up today referencing
        response data.
      x-example: '052022'
  responses:
    Get200_GlobalPosition:
      description: OK
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/_GetGlobalPositionResponse'
    NoContent:
      description: No content
    BadRequest:
      description: Bad request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
    Unauthorized:
      description: Unauthorized
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
    Forbidden:
      description: Forbidden
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
    NotFound:
      description: Not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
    UnsupportedMediaType:
      description: Unsupported media type
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
    InternalServerError:
      description: Internal server error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
    ServiceUnavailable:
      description: Service unavailable
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
    GatewayTimeout:
      description: Gateway timeout
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Errors'
  securitySchemes:
    clientID:
      type: apiKey
      in: header
      name: X-IBM-Client-Id

```

- 4 : API Manager Drafts APIs Upload (Optional & Not Recommended): It is not a mandatory requirement to deploy the generated Api artifact in the Api Manager's draft area, although some entities prefer to leave a copy in this area.
It must be kept in mind the Api Deploymnt Artifact can be modified manually for someone that has access to this area , and after that the Api could be deployed without Gluon Controls.
It is important to understand that the execution of this step does not include the deployment of the Api on a gateway.

![API Manager Drafts APIs](../assets/images/api-connect-draft-apis.png){: .image-popup align="center" style="width:70%"}<br>
The command of the Api Connect Toolkit according to the official IBM documentation would be as follows: apic draft-apis:create [flags] DRAFT_API_FILE .<br>
A real example in an Api Connect Installation 10.0.5 LTS:<br>
 Prerequirements:login has previously done

```bash
./apic draft-apis:create --server https://apicgl-apim.sgtech.gs.corp --org gluon-paas testversioning_2.0.0.yaml
```

![Draft Api Example](../assets/images/api-connect-draft-api-example.png){: .image-popup align="center" style="width:80%"}<br>

[Official Documentation Command Link](https://www.ibm.com/docs/sv/api-connect/10.0.5.x_lts?topic=apis-apic-draft-apiscreate)

- 5 : Product Configuration : An Api Product is a collection of plans , each of them configured with details about the rate limit allowed , the subscription model and the visibility in the api portal.
In addition each plan can offer one or more Apis. Finally , for each Api it´s possible to configure the operations allowed per plan.
As the objective is to allow the deployment of several Apis in the same product , the product deployment artifact must be decoupled of the Api Deployment Repository and has to be built in a different one.
The information required can be shown in the following figure:

![API Product Configuration](../assets/images/api-connect-product.png){: .image-popup align="center" style="width:70%"}<br>
![API Product Configuration](../assets/images/api-connect-product-example.png){: .image-popup align="center" style="width:70%"}<br>

- 6: API Manager Drafts Products (Optional & Not Recommended): This step is optional & not recommendd in the same way as step 4. If it´s executed the Api Product will be deployed only in drafts section of the Api Manager.

![API Product Configuration](../assets/images/api-connect-draft-product.png){: .image-popup align="center" style="width:70%"}<br>
The command according to the official IBM documentation would be as follows: apic draft-products:create [flags] DRAFT_PRODUCT_FILE<br>
A real example in an Api Connect Installation 10.0.5 LTS:<br>
 Prerequirements:login has previously done, it is necessary to have all the api deployment artifacts in the same directory as the product deployment artifact

```bash
./apic draft-products:create --server https://apicgl-apim.sgtech.gs.corp --org gluon-paas testVersioning2Product_1.0.0.yaml
```

![Draft Product Example](../assets/images/api-connect-draft-product-example.png){: .image-popup align="center" style="width:80%"}<br>

[Official Documentation Command Link](https://www.ibm.com/docs/sv/api-connect/10.0.x?topic=products-apic-draft-productscreate)

- 7: Product Deployment :

This step includes the publication of all deployment artifacts involved (Apis & Product) to the Api Manager. It is required to include the catalog, spaces if they are used, and the gateway services you want to expose the APIs.

Publish the Product and the Api in the Catalog & Gateway Services will be done with the following command: apic products:publish [flags] PRODUCT_FILE<br>
A real example in an Api Connect Installation 10.0.5 LTS:<br>
Prerequirements:login has previously done, it is necessary to have all the api deployment artifacts in the same directory as the product deployment artifact<br>
Notice: It can be used catalog name or id  

```bash
./apic products:publish --server https://apicgl-apim.sgtech.gs.corp --org gluon-paas --catalog intranet-interdomain-customer-overview --gateway_services intranet-cn1-sgt-gluon-tp-poc-cview-bk-pro-id,intranet-cn2-sgt-gluon-tp-poc-cview-bk-pro-id testVersioning2Product_1.0.0.yaml
```

In the case of using spaces the following flag must be used: --space Space (name or id)<br>
[Official Documentation Command Link](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=products-apic-productspublish)

![Product Published Example](../assets/images/api-connect-product-deployed-example.png){: .image-popup align="center" style="width:80%"}<br>

- 8: Api Manager & Gateway Synchronization: Once the step 7 has been executed, this final action is done by IBM Api Connect.
 IBM Api Connect executes a periodical synchronization between the mentioned components and exposed the api included in the product only in the gateway services especified.

![Product Published Example](../assets/images/api-connect-product-deployed-example1.png){: .image-popup align="center" style="width:80%"}<br>
![Product Published Example](../assets/images/api-connect-product-deployed-example2.png){: .image-popup align="center" style="width:80%"}<br>

## Api Lifecycle Operations Guide

### Introduction

The following diagram shows the possible lifecycle states for a Product version, and the Product management operations that move a Product version from one lifecycle state to another.
For example, the Retire operation moves a Product version from the Published to the Retired state.

![Product Lifecycle](../assets/images/api-connect-diagram-product-lifecycle.jpg)<br>

#### Login to the IBM Management API

Before any action  done in this guide it is necessary to log in to the OAuth server.

```bash
curl --location --request POST  'https://apicgl-apim.sgtech.gs.corp/api/token' \ # https://(ibm_manager_url)/api/token
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "username",
    "password": "password",
    "realm": "provider/default-idp-2",
    "client_id": "7f20bea8-2097-4f6d-b44a-ee93fccb2911",
    "client_secret": "8829cad5-02e8-432b-8696-7c947259919e",
    "grant_type": "password"
}'
```

#### Oauth Server

<div class="cards row-auto" markdown>
  The Oauth Server used for this guide is SOS. [Official Documentation SOS Link](https://san-sgt-basic.atlassian.net/wiki/spaces/ARCHSEC/pages/447843035/Security+OAuth+Server.+S.O.S.)
</div>

### Credential Management

#### Client

- Depending on the case, the creation of a new client id, and optionally, a client secret, will be required.
In the case of public clients, it is not necessary to generate the client secret. First, it is created on the OAuth server, and later it is ingested into the manager.

#### Core

- In the core case, it is only necessary to create a Client Id + secret, and those created in the Api Connect manager can be used directly.

#### Example Credential Management Client (not public clients)

```bash
#Only for Client (Generate Client ID in Outh Server)
curl --location --request POST 'https://SOSHost/manager/oauth/clients' \
--header 'Authorization: Basic QWRtaadfafadfafafaJBX1NDSUI6MTM0TUNnZSE=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "accessTokenValiditySeconds": "3600",
    "refreshTokenValiditySeconds": 3600,
    "authorizedGrantTypes": ["client_credentials"]
}'
#Example Call (For other grants different from Authorizaion code redirect uri is not needed)
#https://{{ ibm_manager_url }}/api/consumer-orgs/{{ producer_org }}/{{ catalog_id }}/{{ consumer_org_id }}/apps
curl --location --request POST 'https://apicgl-apim.sgtech.gs.corp/api/consumer-orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/apps' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer token' \
--data '{
    "title":"app_title",
    "name":"app-name",
    "summary":"Description .:-,;_",
    "redirect_endpoints":["https://localhost"],
    "client_id":"1e8f9574-fb9b-4509-80e6-d863938d3b8e",
    "client_secret":"***",
    "metadata":{"channel_tp":"<channel_tp>"}
}'
#Example Response
{
    "type": "app",
    "api_version": "2.0.0",
    "id": "c9424b48-b8d9-414c-928f-9c64e783e1dd",
    "name": "app-name",
    "title": "app_title",
    "summary": "Description .:-,;_",
    "state": "enabled",
    "redirect_endpoints": [
        "https://localhost"
    ],
    "lifecycle_state": "production",
    "metadata": {
        "channel_tp": "<channel_tp>"
    },
    "created_at": "2024-06-24T13:36:20.071Z",
    "updated_at": "2024-06-24T13:36:20.071Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "catalog_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26",
    "consumer_org_url": "https://apicgl-platform.sgtech.gs.corp/api/consumer-orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/c9424b48-b8d9-414c-928f-9c64e783e1dd",
    "app_credential_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/c9424b48-b8d9-414c-928f-9c64e783e1dd/credentials/c2911c13-77dc-4caf-a0a5-395e97ad8cb5"
    ],
    "client_secret": "***",
    "client_id": "58c9bfac-64f7-4eb4-bc6a-f6ebf0c9f5b5"
}
```

#### Example Credential Management Core

```bash
#Example Call
#https://{{ibm_manager_url}}/api/consumer-orgs/{{producer_org}}/{{catalog_id}}/{{consumer_org_id}}/apps
curl --location --request POST 'https://apicgl-apim.sgtech.gs.corp/api/consumer-orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/apps' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGcXw' \
--data '{
    "title":"app_title",
    "name":"app-name",
    "summary":"Description .:-,;_"
}'
#Example Response
{
    "type": "app",
    "api_version": "2.0.0",
    "id": "e46828f1-9869-467a-9abf-883cce3e8960",
    "name": "app-name-2024-06-25t13-14-25-739z",
    "title": "app_title_2024-06-25T13:14:25.739Z",
    "summary": "Description .:-,;_",
    "state": "enabled",
    "lifecycle_state": "production",
    "created_at": "2024-06-25T13:14:25.836Z",
    "updated_at": "2024-06-25T13:14:25.836Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "catalog_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26",
    "consumer_org_url": "https://apicgl-platform.sgtech.gs.corp/api/consumer-orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/e46828f1-9869-467a-9abf-883cce3e8960",
    "app_credential_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/e46828f1-9869-467a-9abf-883cce3e8960/credentials/20f4706f-45f3-4691-9f5c-99c2ed5aa68a"
    ],
    "client_secret": "7f23451b4e8f123d155bf28c358acc0f",
    "client_id": "13e2a3305fdc14c7795ced0bae71e068"
}
```

### Subscription

#### Client

- Subscription to the consumption plan in manager
- Registration of scopes in OAuth server
- Registration of scopes in OAuth provider

#### Core

- Subscription to the consumption plan in manager

#### Example

```bash
# Example Call
# {{ibm_manager_url}}/api/apps/{{producer_org}}/{{catalog_id}}/{{consumer_org_id}}/{{app_id}}/subscriptions/
curl --location --request POST 'https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/3a1ff698-3031-4c0f-8c77-40fc758a30d0/subscriptions' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSL85PIWKby1SKPoFiXA' \
--data '{
    "plan": "default-plan",
    "product_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/93a58618-8dce-40b8-b06a-e0dc65cdfe7c"
}'
# Example Response

{
    "type": "subscription",
    "api_version": "2.0.0",
    "id": "523c5032-46a1-4c46-ac48-1c48f0144a18",
    "name": "523c5032-46a1-4c46-ac48-1c48f0144a18",
    "title": "523c5032-46a1-4c46-ac48-1c48f0144a18",
    "state": "enabled",
    "plan": "default-plan",
    "product_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/93a58618-8dce-40b8-b06a-e0dc65cdfe7c",
    "plan_title": "Default Plan",
    "task_urls": [],
    "created_at": "2024-06-27T14:20:44.762Z",
    "updated_at": "2024-06-27T14:20:44.762Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "catalog_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26",
    "consumer_org_url": "https://apicgl-platform.sgtech.gs.corp/api/consumer-orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba",
    "app_url": "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/3a1ff698-3031-4c0f-8c77-40fc758a30d0",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/3a1ff698-3031-4c0f-8c77-40fc758a30d0/subscriptions/523c5032-46a1-4c46-ac48-1c48f0144a18"
}

# Registration in Oauth Server
#https://SOSHost/manager/oauth/clients/{client-id}/scopes
curl --location --request POST 'https://SOSHost/manager/oauth/clients/test-operational-paas-client-id/scopes' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic YWRtaW5fX3Rlc3Q6YWRtaW4=' \
--data '{"scope": ["read"],"authorizedGrantTypes": ["authorization_code"],"autoApproveScopes": ["read"]}'

# Example response
{
    "clientId": "test-paas-client-credentials-id",
    "scope": [
        "accounts.read",
        "read"
    ],
    "grantsAssignedToScopes": [
        {
            "scope": "accounts.read",
            "grants": [
                "client_credentials"
            ],
            "autoApproved": true
        },
        {
            "scope": "read",
            "grants": [
                "client_credentials"
            ],
            "autoApproved": true
        }
    ],
    "scopesDetails": [
        {
            "scope": "accounts.read",
            "grants": [
                "client_credentials"
            ],
            "clientAuthentication": "client_secret_basic",
            "autoApproved": true
        },
        {
            "scope": "read",
            "grants": [
                "client_credentials"
            ],
            "clientAuthentication": "client_secret_basic",
            "autoApproved": true
        }
    ],
    "authorizedGrantTypes": [
        "client_credentials"
    ],
    "registeredRedirectUris": [],
    "autoApproveScopes": [
        "accounts.read",
        "read"
    ],
    "accessTokenValiditySeconds": 2592000,
    "additionalInformation": "Additional information for client credentials id",
    "clientAuthorities": [],
    "refreshTokenValiditySeconds": 2000,
    "client_type": "confidential"
}

# Registration in Outh Provider

curl --location --request PATCH 'https://apicgl-apim.sgtech.gs.corp/api/orgs/gluon-paas/oauth-providers/outh-intranet-client' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOi7686d6' \
--data '{
    "type": "oauth_provider",
    "api_version": "2.0.0",
    "id": "075985fc-bc8a-4667-a4c8-6934dce452c6",
    "name": "outh-intranet-client",
    "title": "Outh Intranet Client",
    "debug": false,
    "owned": true,
    "provider_type": "third_party",
    "scopes": {
        "read": "read",
        "sample_scope_1": "Sample scope description 1",
        "sample_scope_2": "Sample scope description 2"
    },
    "grants": [
        "access_code",
        "application"
    ],
    "gateway_version": "6000",
    "advanced_scope": {
        "override_endpoint_from_api": false
    },
    "third_party_config": {
        "token_validation_requirement": "active",
        "introspection_endpoint": {
            "endpoint": "https://example.com/oauth2/introspect"
        },
        "authorize_endpoint": "https://example.com/oauth2/authorize",
        "token_endpoint": "https://example.com/oauth2/token",
        "security": [
            "basic-auth"
        ],
        "basic_auth": {
            "request_headername": "x-introspect-basic-authorization-header"
        },
        "auth_header_pass_thru": false,
        "introspect_cache_type": "no-cache",
        "advanced_scope_security": {
            "enabled": false,
            "mode": [
                "basic-auth"
            ],
            "basic_auth": {
                "request_headername": "x-advanced-scope-basic-authorization-header"
            }
        }
    },
    "user_registry_urls": [],
    "tls_client_profile_urls": [],
    "created_at": "2024-06-27T14:34:49.000Z",
    "updated_at": "2024-06-27T14:35:18.000Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/oauth-providers/075985fc-bc8a-4667-a4c8-6934dce452c6"
}'

# Example Response (If you need to delete an scope first you have to make a patch assigning a null to the scopes object ("scopes":null) and then you make the patch will all of the scopes remaining )
{
    "type": "oauth_provider",
    "api_version": "2.0.0",
    "id": "075985fc-bc8a-4667-a4c8-6934dce452c6",
    "name": "outh-intranet-client",
    "title": "Outh Intranet Client",
    "debug": false,
    "owned": true,
    "provider_type": "third_party",
    "scopes": {
        "read": "read",
        "sample_scope_1": "Sample scope description 1",
        "sample_scope_2": "Sample scope description 2"
    },
    "grants": [
        "access_code",
        "application"
    ],
    "gateway_version": "6000",
    "advanced_scope": {
        "override_endpoint_from_api": false
    },
    "third_party_config": {
        "token_validation_requirement": "active",
        "introspection_endpoint": {
            "endpoint": "https://example.com/oauth2/introspect"
        },
        "authorize_endpoint": "https://example.com/oauth2/authorize",
        "token_endpoint": "https://example.com/oauth2/token",
        "security": [
            "basic-auth"
        ],
        "basic_auth": {
            "request_headername": "x-introspect-basic-authorization-header"
        },
        "auth_header_pass_thru": false,
        "introspect_cache_type": "no-cache",
        "advanced_scope_security": {
            "enabled": false,
            "mode": [
                "basic-auth"
            ],
            "basic_auth": {
                "request_headername": "x-advanced-scope-basic-authorization-header"
            }
        }
    },
    "user_registry_urls": [],
    "tls_client_profile_urls": [],
    "created_at": "2024-06-27T14:34:49.000Z",
    "updated_at": "2024-06-27T15:02:35.496Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/oauth-providers/075985fc-bc8a-4667-a4c8-6934dce452c6"
}

```

### Subscription Revoke

Is the Api Management Lifecycle step that consists of removing the subscription record from the API management system.

```bash
# Example Call
# {{ibm_manager_url}}/api/apps/{{producer_org}}/{{catalog_id}}/{{consumer_org_id}}/{{app_id}}/subscriptions/{{subscription_id}}

curl --location --request DELETE 'https://apicgl-apim.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/576df901-dd4f-4864-95ef-8c2d875308f5/subscriptions/075985fc-bc8a-4667-a4c8-6934dce452c6' \
--header 'Authorization: ••••••' \
--data ''


```

### Subscription Migration

Is the process of moving API subscriptions from one version of an API or product to another.
This process is crucial when an API or product is updated or deprecated, and consumers need to be transitioned to the new version to maintain functionality and access.
Use cases:

- Release & fix: The migration can be carried out without any impact.
- Major versioning: The previous subscription is not automatically removed, the subscriptions for consumers for both products are active.

#### Client

- Before migrating: At least, the plan must have the same operations as the original plan, for each API in the plan, and with at least the same rate limit.
In other words, a release or a fix. Backward compatible versioning. Previously, new scopes must be checked.

#### Example

```bash
#Migration Call
#https://{{ ibm_manager_url }}/api/catalogs/{{ producer_org }}/{{ catalog_id }}/products/{{ product_id }}/migrate-subscriptions
curl --location 'https://apicgl-apim.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/93a58618-8dce-40b8-b06a-e0dc65cdfe7c/migrate-subscriptions' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI' \
--data '{"subscription_urls":["https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/3a1ff698-3031-4c0f-8c77-40fc758a30d0/subscriptions/7d83f1e5-bc3e-4bf7-ae59-f1dec0e28eb3"],"product_url":"https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/621429fb-4069-47fa-8655-db81e65c79f7","plans":[{"source":"default-plan","target":"default-plan"}]}'
#subscription_urls={{ibm_manager_url}}/api/apps/{{producer_org}}/{{catalog_id}}/{{consumer_org_id}}/{{app_id}}/subscriptions/{{subscription_id}}

#Migration Response

{
    "type": "product",
    "api_version": "2.0.0",
    "id": "93a58618-8dce-40b8-b06a-e0dc65cdfe7c",
    "name": "holaproduct",
    "version": "1.0.0",
    "title": "holaproduct",
    "state": "published",
    "scope": "catalog",
    "gateway_types": [
        "datapower-api-gateway"
    ],
    "gateway_service_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/configured-gateway-services/34096a7e-150a-45ec-b359-fb90b96f2b1b",
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/configured-gateway-services/f778f1b5-f364-4d8a-beda-1b8fe46432d3"
    ],
    "visibility": {
        "view": {
            "type": "public",
            "enabled": true
        },
        "subscribe": {
            "type": "authenticated",
            "enabled": true
        }
    },
    "api_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/83b8327a-ecf6-4d95-8165-b83a33434ffa",
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/67543b83-7b8a-494f-b0d0-269a485b3454"
    ],
    "oauth_provider_urls": [],
    "billing_urls": [],
    "plans": [
        {
            "apis": [
                {
                    "id": "83b8327a-ecf6-4d95-8165-b83a33434ffa",
                    "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/83b8327a-ecf6-4d95-8165-b83a33434ffa",
                    "name": "testversioning2",
                    "title": "TestVersioning",
                    "version": "1.0.0"
                },
                {
                    "id": "67543b83-7b8a-494f-b0d0-269a485b3454",
                    "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/67543b83-7b8a-494f-b0d0-269a485b3454",
                    "name": "testversioning",
                    "title": "TestVersioning",
                    "version": "1.0.0"
                }
            ],
            "name": "default-plan",
            "title": "Default Plan"
        }
    ],
    "task_urls": [],
    "created_at": "2024-06-24T13:23:38.000Z",
    "updated_at": "2024-06-24T13:23:38.000Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "catalog_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/93a58618-8dce-40b8-b06a-e0dc65cdfe7c"
}
```

### Deprecating

When a Product is deprecated, the Product version is only visible to applications that are currently subscribed. Additionally , new subscriptions will not be allowed but it remains enabled for old subscriptions.

- API Call to the IBM management Api that prevents new subscriptions

#### Example

```bash
#Deprecation Call
#https://{{ ibm_manager_url }}/api/catalogs/{{ producer_org }}/{{ catalog_id }}/products/{{ product_id }}
curl --location --request PATCH 'https://apicgl-apim.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/621429fb-4069-47fa-8655-db81e65c79f7' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImGqSg' \
--data '{
"state": "deprecated"
}'


#Deprecation Response
{
    "type": "product",
    "api_version": "2.0.0",
    "id": "621429fb-4069-47fa-8655-db81e65c79f7",
    "name": "testversioning2",
    "version": "1.0.0",
    "title": "testVersioning2",
    "state": "deprecated",
    "scope": "catalog",
    "gateway_types": [
        "datapower-api-gateway"
    ],
    "gateway_service_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/configured-gateway-services/34096a7e-150a-45ec-b359-fb90b96f2b1b",
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/configured-gateway-services/f778f1b5-f364-4d8a-beda-1b8fe46432d3"
    ],
    "visibility": {
        "view": {
            "type": "public",
            "enabled": true
        },
        "subscribe": {
            "type": "authenticated",
            "enabled": true
        }
    },
    "api_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/83b8327a-ecf6-4d95-8165-b83a33434ffa"
    ],
    "oauth_provider_urls": [],
    "billing_urls": [],
    "plans": [
        {
            "apis": [
                {
                    "id": "83b8327a-ecf6-4d95-8165-b83a33434ffa",
                    "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/83b8327a-ecf6-4d95-8165-b83a33434ffa",
                    "name": "testversioning2",
                    "title": "TestVersioning",
                    "version": "1.0.0"
                }
            ],
            "name": "default-plan",
            "title": "Default Plan"
        }
    ],
    "task_urls": [],
    "created_at": "2024-05-16T15:41:44.000Z",
    "updated_at": "2024-06-24T12:58:40.356Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "catalog_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/621429fb-4069-47fa-8655-db81e65c79f7"
}
```

### Retiring

When a Product is retired, the Product version is not available, and all associated APIs are unlinked from the product.

#### Client

- Check that there are no subscriptions
- Theoretically, the scopes should be removed. But until there is a thesis that scopes are not shared by APIs, it is a complex operation that is not recommended to be done.
- Retiring

#### Core

- Check that there are no subscriptions
- Retiring

#### Example

```bash

# Check subscriptions
#https://{{ ibm_manager_url }}/api/catalogs/{{producer_org}}/{{catalog_id}}/subscriptions?limit=1000&offset=0&fields=app,consumer_org,id,plan,plan_title,product,product_version,state,updated_at,url&expand=product,app,consumer_org&product_url=https://apicgl-platform.sgtech.gs.corp/api/catalogs/{{producer_org}}/{{catalog_id}}/products/{product_id}
curl --location --request GET 'https://apicgl-apim.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/subscriptions?limit=1000&offset=0&fields=app%2Cconsumer_org%2Cid%2Cplan%2Cplan_title%2Cproduct%2Cproduct_version%2Cstate%2Cupdated_at%2Curl&expand=product%2Capp%2Cconsumer_org&product_url=https%3A%2F%2Fapicgl-platform.sgtech.gs.corp%2Fapi%2Fcatalogs%2F2a2cb654-e0b2-41e2-bc5b-df24840d3924%2F70862970-e5d2-450a-a8f4-08ef0264ce26%2Fproducts%2F93a58618-8dce-40b8-b06a-e0dc65cdfe7c' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1e7686d6' \
--data ''

#Example Response Subscription Available for product "testVersioning2"
{
    "total_results": 1,
    "results": [
        {
            "app": {
                "id": "3a1ff698-3031-4c0f-8c77-40fc758a30d0",
                "title": "app_title_2024-06-24T12:42:20.808Z",
                "name": "app-name-2024-06-24t12-42-20-808z",
                "url": "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/3a1ff698-3031-4c0f-8c77-40fc758a30d0",
                "credentials": [
                    {
                        "id": "0d65610e-bb35-41cc-9d00-aa5783435aff",
                        "url": "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/3a1ff698-3031-4c0f-8c77-40fc758a30d0/credentials/0d65610e-bb35-41cc-9d00-aa5783435aff",
                        "name": "Credential-for-app_title_2024-06-24T12-42-20.808Z",
                        "title": "Credential for app_title_2024-06-24T12:42:20.808Z",
                        "client_id": "3d2ab368-a96a-4bd1-95bc-211022de9437"
                    }
                ]
            },
            "consumer_org": {
                "id": "47ddb8f1-affd-4ce1-9d42-364f58537dba",
                "title": "tes-policy",
                "name": "tes-policy",
                "url": "https://apicgl-platform.sgtech.gs.corp/api/consumer-orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba"
            },
            "id": "7d83f1e5-bc3e-4bf7-ae59-f1dec0e28eb3",
            "plan": "default-plan",
            "plan_title": "Default Plan",
            "product": {
                "id": "93a58618-8dce-40b8-b06a-e0dc65cdfe7c",
                "title": "holaproduct",
                "name": "holaproduct",
                "version": "1.0.0",
                "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/93a58618-8dce-40b8-b06a-e0dc65cdfe7c"
            },
            "state": "enabled",
            "updated_at": "2024-06-24T13:27:01.000Z",
            "url": "https://apicgl-platform.sgtech.gs.corp/api/apps/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/47ddb8f1-affd-4ce1-9d42-364f58537dba/3a1ff698-3031-4c0f-8c77-40fc758a30d0/subscriptions/7d83f1e5-bc3e-4bf7-ae59-f1dec0e28eb3"
        }
    ]
}
#Example Response Subscription Unavailable for product "testVersioning2"
{
    "total_results": 0,
    "results": []
}
#Example Call (Be Careful it deletes subscriptions)
#https://{{ ibm_manager_url }}/api/catalogs/{{ producer_org }}/{{ catalog_id }}/products/{{ product_id }}
curl --location --request PATCH 'https://apicgl-apim.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/621429fb-4069-47fa-8655-db81e65c79f7' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1Ni='  \
--data '{
"state": "retired"
}'

#Example Response
{
    "type": "product",
    "api_version": "2.0.0",
    "id": "621429fb-4069-47fa-8655-db81e65c79f7",
    "name": "testversioning2",
    "version": "1.0.0",
    "title": "testVersioning2",
    "state": "retired",
    "scope": "catalog",
    "gateway_types": [
        "datapower-api-gateway"
    ],
    "gateway_service_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/configured-gateway-services/34096a7e-150a-45ec-b359-fb90b96f2b1b",
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/configured-gateway-services/f778f1b5-f364-4d8a-beda-1b8fe46432d3"
    ],
    "visibility": {
        "view": {
            "type": "public",
            "enabled": true
        },
        "subscribe": {
            "type": "authenticated",
            "enabled": true
        }
    },
    "api_urls": [
        "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/83b8327a-ecf6-4d95-8165-b83a33434ffa"
    ],
    "oauth_provider_urls": [],
    "billing_urls": [],
    "plans": [
        {
            "apis": [
                {
                    "id": "83b8327a-ecf6-4d95-8165-b83a33434ffa",
                    "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/apis/83b8327a-ecf6-4d95-8165-b83a33434ffa",
                    "name": "testversioning2",
                    "title": "TestVersioning",
                    "version": "1.0.0"
                }
            ],
            "name": "default-plan",
            "title": "Default Plan"
        }
    ],
    "task_urls": [],
    "created_at": "2024-05-16T15:41:44.000Z",
    "updated_at": "2024-06-24T08:55:07.411Z",
    "org_url": "https://apicgl-platform.sgtech.gs.corp/api/orgs/2a2cb654-e0b2-41e2-bc5b-df24840d3924",
    "catalog_url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26",
    "url": "https://apicgl-platform.sgtech.gs.corp/api/catalogs/2a2cb654-e0b2-41e2-bc5b-df24840d3924/70862970-e5d2-450a-a8f4-08ef0264ce26/products/621429fb-4069-47fa-8655-db81e65c79f7"
```

### Versioning

The design guide containing all possible versioning use cases is available [here](../../guides/apis/apiversioning.md).
