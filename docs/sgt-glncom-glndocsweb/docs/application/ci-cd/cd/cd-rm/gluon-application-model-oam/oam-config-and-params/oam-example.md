# **Gluon Application Model (OAM) Example**

```YAML
kind: Application
version: v1

metadata:
  name: GLUON XXX
  version: 0.0.1

environments:
  - name: cert
    type: certification
    infrastructures:
      - id: CI00000000097
        properties:
          type: IBM
          credentialUserId: APICONNECT_USER_DEV
          credentialPassId: APICONNECT_USER_DEV_PASS
          company: scib
          exposure: intranet
          security-type: core
          mode: live
          manager-url: api-manager.scib.dev.corp
          kid: apimscib-intranet
          private-key-id: apimscib-intranet
          sca-iss: ''
          sca-token_in: ''
          sca-token-type: ''
          manager-subscription-user: ''
          manager-subscription-password: ''
          oauth-url-management: ''
          oauth-user: ''
          oauth-pass: ''
          oauth-type: ''
          authorization-url: https://$(auth-security-url)
          token-url: https://$(token-security-url)
          organization: scib
          catalog: gluon-apic
          space: true
          service: intranet-core
          x-ibm-oauth-provider: gluon-test-provider
          realm: provider/ldap-apim
          clientId-toolkit: ''
          client-secret-toolkit: ''
          producer-org-id: f3b29b70-b6d4-482b-a723-5cf4c762cb30
          catalog-id: 95239486-3c62-47f1-b420-4ad0add9253b
          catalog-original-id: ''
          identity-provider: ''
          gateway-service-url: https://test

      - id: CI00000000100
        properties:
          type: APIGEE
          credentialUserId: APIGEE_USER_DEV
          credentialPassId: APIGEE_USER_DEV_PASS
          company: scib
          exposure: intranet
          security-type: client
          mode: live
          manager-url: https://api-management.sgtech.dev.corp
          kid: apimscib-intranet
          private-key-id: apimscib-intranet
          jwe-private-key-id: ''
          sca-iss: ''
          sca-token-origin: ''
          sca-token-type: ''
          manager-subscription-user: ''
          manager-subscription-password: ''
          organization: desarrollo
          execution-environment: intranet
          virtual-host: default
          virtual-host-url: http://url12345
          company-developer-administrator-email: santander.developer.svc@gruposantander.com
          company-developer-administrator-firstName: Santander Developer
          company-developer-administrator-lastName: Service Account
          oauth-url-management: ''
          oauth-user: ''
          oauth-pass: ''
          oauth-type: SOS
          authorization-url: https://$(auth-security-url)
          token-url: https://$(token-security-url)
          introspect-url: https://$(security-url)

      - id: CI00000000006
        type: KUBERNETES
        properties:
          type: KUBERNETES
          apiServer: https://cibaks-ea2de9a7.hcp.westeurope.azmk8s.io:443
          namespace: app360-cert
          credentialUserId: AKS_USER
          credentialPassId: AKS_PASSWORD
          provider: aks
          cloud: azure
          account: 0345214e-311c-42fd-a0bf-1725071c896d
          clusterName: cibd1weuaksdevopscrit003
          tenant: 35595a02-4d6d-44ac-99e1-f9ab4cd872db
          resourceGroup: cibd1weursgdevopscrit001
          application: application-name-cluster
          artifact-store: CI00000001001

      - id: CI00000000012
        type: KUBERNETES
        properties:
          type: KUBERNETES
          apiServer: https://67D8C306CE581B492A3D3B1366C5B614.sk1.eu-west-1.eks.amazonaws.com
          namespace: app360-dev
          credentialUserId: GLUON_AWS_ACCESS_KEY_ID
          credentialPassId: GLUON_AWS_SECRET_ACCESS_KEY_ID
          provider: eks
          cloud: aws
          account: 665313331585
          role: AccountAutomationNonPro
          region: eu-west-1
          clusterName: sgtd1aireksgluondeksd001
          deployStrategy: none
          application: application-name-cluster
          credentialsFromVault: false
          artifact-store: CI00000002001

      - id: CI00000000013
        type: KUBERNETES
        properties:
          type: KUBERNETES
          apiServer: https://api.ccc01alm.ccc.pre.cn1.paas.cloudcenter.corp:6443
          namespace: app360-cert-pre
          credentialsId: APP360_CERT_PRE_TOKEN
          deployStrategy: none
          application: application-name-cluster
          credentialsFromVault: false
          artifact-store: CI00000003001

      - id: CI00000000035
        type: ANSIBLE
        properties:
          type: ANSIBLE
          ansibleCredentialUser: ANSIBLECREDENTIALUSER_CERT
          ansibleCredentialPassword: ANSIBLECREDENTIALPASSWORD_CERT
          inventoryGit: ansible-organization/project-inventory-test
          inventoryGitBranch: gluon-test-ansible
          inventory: CERT/host
          limit: CERT
          tag: test
          ansibleGalaxy: true
          requirements: test-requirements.yml
          disableMitogen: false
          mitogenStrategy: mitogen_free
          mitogenVersion: 0.3.3
          ansibleGalaxy: true

      - id: CI00000001001
        type: ARTIFACT-STORE
        properties:
          type: acr
          registry: sgtacrprueba.azurecr.io
          project-path: sgt-app360-cert
          usernameId: AZ_USERNAME
          passwordId: AZ_PASSWORD
          account: sgtd2glbsubgeneriglob001
          tenant: 35595a02-4d6d-44ac-99e1-f9ab4cd872db
          snapshots: true

      - id: CI00000002001
        type: ARTIFACT-STORE
        properties:
          type: ecr
          registry: 665313331585.dkr.ecr.eu-west-1.amazonaws.com
          project-path: sgt-app360
          usernameId: GLUON_AWS_ACCESS_KEY_ID
          passwordId: GLUON_AWS_SECRET_ACCESS_KEY_ID
          role: AccountAutomationNonPro
          snapshots: true

      - id: CI00000003001
        type: ARTIFACT-STORE
        properties:
          type: harbor
          registry: registry.global.ccc.srvb.bo.paas.cloudcenter.corp
          project-path: app360-cert
          usernameId: REGISTRY_BO_USERNAME
          passwordId: REGISTRY_BO_PASSWORD
          snapshots: true

  - name: pre
    type: preproduction
    infrastructures:
      - id: CI000000000062
        type: KUBERNETES
        properties:
          type: KUBERNETES
          apiServer: https://cibaks-ea2de9a7.hcp.westeurope.azmk8s.io:443
          namespace: app360-cert
          credentialUserId: AKS_USER
          credentialPassId: AKS_PASSWORD
          provider: aks
          cloud: azure
          account: 0345214e-311c-42fd-a0bf-1725071c896d
          clusterName: cibd1weuaksdevopscrit003
          tenant: 35595a02-4d6d-44ac-99e1-f9ab4cd872db
          resourceGroup: cibd1weursgdevopscrit001
          application: application-name-cluster
          artifact-store: CI000000010012

      - id: CI000000010012
        type: ARTIFACT-STORE
        properties:
          type: acr
          registry: sgtacrprueba.azurecr.io
          project-path: sgt-app360-cert
          usernameId: AZ_USERNAME
          passwordId: AZ_PASSWORD
          account: sgtd2glbsubgeneriglob001
          tenant: 35595a02-4d6d-44ac-99e1-f9ab4cd872db
          snapshots: true

  - name: pro
    type: production
    infrastructures:
      - id: CI000000000133
        type: KUBERNETES
        properties:
          type: KUBERNETES
          apiServer: https://api.ccc01alm.ccc.pre.cn1.paas.cloudcenter.corp:6443
          namespace: app360-cert-pre
          credentialsId: APP360_CERT_PRE_TOKEN
          deployStrategy: none
          application: application-name-cluster
          credentialsFromVault: false
          authType: token
          artifact-store: CI000000030013

      - id: CI000000030013
        type: ARTIFACT-STORE
        properties:
          type: harbor
          registry: registry.global.ccc.srvb.bo.paas.cloudcenter.corp
          project-path: app360-cert
          usernameId: REGISTRY_BO_USERNAME
          passwordId: REGISTRY_BO_PASSWORD
          snapshots: true

trails:
  - name: default-env-trails
    environments:
      - name: cert
        order: 1
      - name: pre
        order: 2
      - name: pro
        order: 3

components:
  - name: "component-config-map-ms"
    version: 1.0.0
    needs: []
  - name: "component-config-map-frontend"
    version: 1.2.5
    needs: []
  - name: "application-secrets-rm"
    version: 1.0.0
    needs: []
  - name: "arsenal-java-microservice"
    version: 1.0.23
    needs: [application-secrets-rm,component-config-map-ms]
  - name: "darwin-frontend"
    version: 0.0.12
    needs: [application-secrets-rm, application-secrets-rm]
```

## **Gluon Application Model OAM Config and Params**

- [OAM Configuration](gluon-application-model-oam-config.md){:target="_blank"}
- [OAM Parameters](gluon-application-model-oam-params.md){:target="_blank"}
