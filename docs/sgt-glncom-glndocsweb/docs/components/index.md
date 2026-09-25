---
title: Gluon Components
hide:
  - toc
---

This section provides the **End-to-End Journey**: A detailed guideline for the development team **to create and deliver gluon components**.

**Gluon Applications are made of one or more Gluon Components**:  

- [**Software components**](#software-components-journey) contain applications business logic (e.g. microservice). Software components are associated to development technologies.  
- [**Configuration components**](#configuration-components-journey) contain any additional data required to release and operate the application (e.g. environment variables).

[**Development Frameworks and Standards**](#development-frameworks) are provided to be followed by the development team, in order to improve applications quality.

## **Software Components Journey**

<div class="cards row-auto" markdown>

- ### :material-web: Frontend

    ---

    **SPA/Shell**  
    [Darwin](./software/front/web/darwin/spa.md)  

    ---
    **Microfront**  
    [Darwin](./software/front/web/darwin/mfe.md)

    ---
    **Mobile**  
    [Android](software/front/mobile/android/lib.md)
    [iOS](software/front/mobile/ios/app.md)

- ### :fontawesome-solid-puzzle-piece: Backend

    ---

    **Microservices**  
    Java: [Santander Spring Boot](./software/backend/java/santander/ms.md),
     [Photon](./software/backend/java/photon/photon-maven-kubernetes.md)  
    Python: [Darwin](./software/backend/python/darwin/darwin-python-journey.md)  
    NodeJS: [Darwin](./software/backend/nodejs/darwin/darwin-node-journey.md)  

    ---
    **Libraries**  
    Java: [Santander Spring Boot](./software/backend/java/santander/lib.md), [Photon](./software/backend/java/photon/photon-maven-extension.md)  
    Python: [Darwin](./software/backend/python/darwin/darwin-python.md), [Javascript](./software/backend/nodejs/darwin/darwin-node.md)  
    NodeJS: [Darwin](./software/backend/nodejs/darwin/darwin-node.md)

- ### :material-transit-connection-variant: Other

    ---
    **APIs**  
    [Gluon APIs](./software/api/apideployment/apis.md)  

    ---
    **Events**  
    [Gluon Events](./software/events/index.md)  

    ---
    **Processes**  
    [Appian BPM](./software/processes/appian-processes-component.md)  

    **Observability**  
    [Gluon Observability](./software/observability/index.md)

</div>

## **Configuration Components Journey**

<div class="cards row-auto" markdown>

- ### :material-check-all: Testing

    ---

    [TalosBDD](./configuration/testing/talosbdd/journey/talosbdd-testing-journey.md)  
    [Newman](./configuration/testing/newman/journey/newman-testing-journey.md)  
    [Nitro](./configuration/testing/nitro/journey/nitro-testing-journey.md)  
    [Cilantrum](./configuration/testing/cilantrum/journey/cilantrum-testing-journey.md)  
    [Jmeter](./configuration/testing/jmeter/journey/jmeter-testing-journey.md)  

- ### :material-security: Security

    ---

    [Public Key Manager (PKM)](https://cipdoc.sgtech.dev.corp/workstream/components/pkm/)  
    [Security Token Server (STS)](https://cipdoc.sgtech.dev.corp/workstream/components/sts/)  
    [Oauth Server (OS)](https://cipdoc.sgtech.dev.corp/workstream/components/sos/)  
    [Dynamic Application Security Testing (DAST)](./configuration/app-component/dast/index.md)  

<!-- - ### :material-server-outline: Infrastructure as Code

    ---

    [Application Load Balancer](./configuration/iac/application-load-balancer/application-load-balancer-journey.md)  
    [Container Registry](./configuration/iac/container-registry/container-registry-journey.md)  
    [Encryption Manager](./configuration/iac/encryption-manager/encryption-manager-journey.md)  
    [IAM](./configuration/iac/iam/iam-journey.md)  
    [Kubernetes Cluster](./configuration/iac/kubernetes/kubernetes-journey.md)  
    [Network Load Balancer](./configuration/iac/network-load-balancer/network-load-balancer-journey.md)  
    [Object Storage](./configuration/iac/object-storage/object-storage-journey.md)  
    [Virtual Machines](./configuration/iac/virtual-machine/vm.md)  
    [VPC Lite](./configuration/iac/vpc-lite/vpc-lite-journey.md)   -->

- ### :material-truck-delivery: Deployment

    ---

    [ConfigMaps](./configuration/kubernetes/configmaps-rm.md)  
    [Application Secrets](./configuration/kubernetes/application-secrets.md)  
    [Namespaces Harbor](./configuration/kubernetes/namespace_harbor.md)  

</div>

## **Development Frameworks**

<div class="cards-no-border cards row-4" markdown>

- ### [:material-diamond-outline: **Software**](./index.md)

    ---

    **Arsenal**  
    [Arsenal -Java](software/backend/java/arsenal/framework/arsenal-backend/index.md)  

    ---
    **Darwin**  
    [Darwin - Java](./software/backend/java/darwin/framework/current/index.md)  
    [Darwin - Python](software/backend/python/darwin/framework/index.md)  
    [Darwin - NodeJS](software/backend/nodejs/darwin/framework/index.md)  
    [Darwin - Frontend](software/front/web/darwin/framework/index.md)

- &nbsp;

    ---

    **Photon**  
    [Photon  - Backend](./software/backend/java/photon/framework/current/index.md)

    ---
    **ODS**  
    [ODS - React](software/front/web/react/framework/index.md)

- ### [:octicons-tools-24: **Configuration**](./index.md)

    ---
    **Testing**  
    [TalosBDD](../components/configuration/testing/talosbdd/framework/index.md)  
    [Nitro](./configuration/testing/nitro/framework/index.md)  
    [Newman](./configuration/testing/newman/framework/index.md)  
    [Cilantrum](./configuration/testing/cilantrum/framework/index.md)  
    [JMeter](./configuration/testing/jmeter/framework/index.md)

</div>

## **Related Content**

<div class="cards row-2" markdown>

- ### [:material-youtube:  **Training videos**](./index.md)

    ---
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/apis/index.md "Gallery :: Gluon Components :: APIs")&nbsp;&nbsp;[Gluon APIs](../training/gluon-components/apis/index.md)  
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/front/index.md "Gallery :: Gluon Components :: Front")&nbsp;&nbsp;[Microfront Architecture](../training/gluon-components/front/index.md)  
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/processes/index.md#appian "Gallery :: Gluon Components :: Appian")&nbsp;&nbsp;[Appian - Processes](../training/gluon-components/processes/index.md#appian)  
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/testing/index.md#talosbdd "Gallery :: Gluon Components :: TalosBDD")&nbsp;&nbsp;[TalosBDD](../training/gluon-components/testing/index.md#talosbdd)  
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/testing/index.md#jmeter "Gallery :: Gluon Components :: Jmetter")&nbsp;&nbsp;[Jmetter](../training/gluon-components/testing/index.md#jmeter)  
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/testing/index.md#dast "Gallery :: Gluon Components :: DAST")&nbsp;&nbsp;[DAST](../training/gluon-components/testing/index.md#dast)  
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/backend/darwin/darwin-java/index.md#darwin-framework "Gallery :: Gluon Components :: Darwin Framework")&nbsp;&nbsp;
    [Darwin Framework](../training/gluon-components/backend/darwin/darwin-java/index.md#darwin-framework)  
    [:fontawesome-brands-youtube:{ .functionalities }](../training/gluon-components/backend/darwin/darwin-java/index.md#darwin-framework "Gallery :: Gluon Components :: Darwin Security Librarie")&nbsp;&nbsp;
    [Darwin Security Libraries](../training/gluon-components/backend/darwin/darwin-java/index.md#darwin-framework)  

- ### [**:octicons-link-external-16: External contents**  :material-link:{.disabled}](./index.md)

    ---
  
    [Angular documentation :material-link:{.disabled}](./../training/gluon-components/backend/darwin/darwin-java/index.md#darwin-framework)  
    [React documentation :material-link:{.disabled}](./../training/gluon-components/backend/darwin/darwin-java/index.md#darwin-framework)

</div>
