# Gluon Technology Stack

The aim of this section is to describe the **Technology Stack** associated with Gluon components.

!!! note "Considerations"
    This Technology Stack **does not include**:

    - Technologies associated with the **infrastructure** on which Gluon components will be **deployed**.
    - Technologies that represent **extra functionalities** to the Gluon components. The technologies included are those associated with the **base components** provided by Gluon.
    - Information associated with the **Runners** provided by Gluon. For more information visit [Ephemeral Runners documentation](../../getting-started/company-management/technical-requirements/ephemeral-runners/index.md).

!!! warning
    Some non-included technologies are **required** and their versions depend on the Software Centre of the consuming entity. For each component these technologies will be clarified.

---

## Backend

The technologies that make up the Gluon components associated with the backend are described below.

### Santander Spring Boot

{!
include-markdown "./snippets/back/santander-spring-boot-java.md"
start="<!--start-->"
end="<!--end-->"
!}

### Darwin Java

{!
   include-markdown "./snippets/back/darwin-java.md"
   start="<!--start-->"
   end="<!--end-->"
!}

### Darwin Nodejs

{!
   include-markdown "./snippets/back/darwin-nodejs.md"
   start="<!--start-->"
   end="<!--end-->"
!}

### Darwin Python

{!
   include-markdown "./snippets/back/darwin-python.md"
   start="<!--start-->"
   end="<!--end-->"
!}

### Arsenal Backend

{!
include-markdown "./snippets/back/arsenal-backend.md"
start="<!--start-->"
end="<!--end-->"
!}

### Arsenal Integration

{!
include-markdown "./snippets/back/arsenal-integration.md"
start="<!--start-->"
end="<!--end-->"
!}

## Security

The technologies that make up the Security Gluon components.

### Public Key Manager

Public Key Manager allows obtaining a public key stored in different ways, from a JKS, Azure Key Vault, MongoDB, in memory configuration or from an external provider.

{!
include-markdown "./snippets/security/pkm.md"
start="<!--start-->"
end="<!--end-->"
!}

### Security Token Service

Security Token Service allows validating and generating tokens to keep SSO between applications.

{!
include-markdown "./snippets/security/sts.md"
start="<!--start-->"
end="<!--end-->"
!}

### Security Oauth Server

SOS implements the standard OAuth2 Authorization Grant and the OpenID Authorization Code Flow, but it has been added custom policies and corporate credentials support.

{!
include-markdown "./snippets/security/sos.md"
start="<!--start-->"
end="<!--end-->"
!}

<br>

<!-- ### Darwin NodeJS

<br>

### Arsenal Java

<br>

--- -->

---

## Front

The technologies that make up the Gluon components associated with the frontend are described below.

### Angular / Darwin

{!
   include-markdown "./snippets/front/angular-darwin.md"
   start="<!--start-->"
   end="<!--end-->"
!}

---

<!-- ### Darwin NodeJS

## Library

One line introduction to the section.

### Darwin Maven

<br>

### Darwin Node

<br>

### Arsenal Maven

<br>

---

## Kubernetes Configuration

One line introduction to the section.

### ConfigMap

<br>

### Secrets

<br>

### Namespaces & Harbor space

<br>

---

## APIs

One line introduction to the section.

<br>

---
-->

## Testing

The technologies that make up the Gluon components associated with the testing are described below.

### TalosBDD

{!
   include-markdown "./snippets/testing/talos-bdd.md"
   start="<!--start-->"
   end="<!--end-->"
!}

<br>

### Nitro

{!
   include-markdown "./snippets/testing/nitro.md"
   start="<!--start-->"
   end="<!--end-->"
!}

<br>

### Newman

{!
   include-markdown "./snippets/testing/newman.md"
   start="<!--start-->"
   end="<!--end-->"
!}

<br>

### Cilantrum

{!
   include-markdown "./snippets/testing/cilantrum.md"
   start="<!--start-->"
   end="<!--end-->"
!}

<br>

### JMeter

{!
   include-markdown "./snippets/testing/jmeter.md"
   start="<!--start-->"
   end="<!--end-->"
!}

<br>

## APIs

### API Managers

{!
   include-markdown "./snippets/apis/apis.md"
   start="<!--start-->"
   end="<!--end-->"
!}

<br>

<!--## Processes

One line introduction to the section.

### Appian

<br>

--- -->
