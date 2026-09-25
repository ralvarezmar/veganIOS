---
title: PowerBI Deployment Journey
---

## Introduction

The purpose of this documentation is to indicate the specific parameters to the PowerBI deployment's.

These parameters will be specified by the user in the cd.yml files of each of the environments that he wishes to deploy.

## How to configure your deployment environment

The PowerBI deployment is orchestrated via Ansible, so the applicable parameters will be those specific to ANSIBLE.

{!
   include-markdown "../../technologies/maven/snippets/snippet-oam-artifact.md"
   start="<!-- infrastructure-description-start -->"
   end="<!-- infrastructure-description-end -->"
!}

``` yaml title="oam-application-definition.yml"
environments:
  - name: cert
    type: certification
    infrastructures:
      - id: CI00000000001
        type: ANSIBLE
        properties:
          type: ANSIBLE
          inventoryGit: santander-group-gluon-test/devsecops.products.file-transfer-unix-inventory-test
          inventoryGitBranch: gluon-test-ansible
          inventory: CERT/host
```

{!
   include-markdown "../../technologies/maven/snippets/snippet-oam-artifact.md"
   start="<!-- infrastructure-cd-start -->"
   end="<!-- infrastructure-cd-end -->"
!}

## Extra PowerBI specific parameters

#### **extra_params**

Parameters injected into the playbook as environment variables:

| Key                    | Description                                                        | Default Value  | Mandatory | Example                                                                 |
| -------------          | ------------------------------------------------------------------ | -------------          | ----------------------------------------------------------------------- | -------------          |
| `ARTIFACT_REPOSITORY_URL`                 | Artifact URl                                    |  -  |  YES  | ${ARTIFACT_REPOSITORY_URL}                                                              |
| `DEPLOYMENT_JSON_FILE` | Deployment file location.  | 'deployment.json'          |  YES  |  'ex-deployment.json'  |
| `USERS_CONFIG_TYPE`    | Configuration user by workspace and specific role (Admin, Contributor, Member, Viewer). This parameter indicates that the configuration will be brought to you from an external repository or it will look for the configuration in the local config directory. Values: git,local |  'local'  |  NO  | 'git' |
| `USERS_CONFIG_SOURCE`  | Configuration user by workspace and specific role (Admin, Contributor, Member, Viewer). If USERS_CONFIG_TYPE='git', it is the url to clone the repository. If USERS_CONFIG_TYPE='local', it is the path to find the configuration.  | './config'  |  NO  | 'https://github.com/org/prj.git' |
| `ENVIRONMENT`          | Target environment to deploy. It must match with the environment defined in DEPLOYMENT_JSON_FILE and the subfolder within configuration  |  -  |  YES  | 'DEV'          |

#### **extra_secret_params**

Secrets obtained from github and converted into environment variables for use
within the ansible playbook or deployment.json. This parameter is a list of:

- id: id of the github secret
- variable: name of the variable to create and use in the ansible playbook

Mandatory secrets:

| Variable               | Description                                                   |
| -------------          | ------------------------------------------------------------------ |
| `AZURE_CLIENT_ID`      | The Azure client ID to use for authentication within the ansible playbook  |
| `AZURE_CLIENT_SECRET`  | The Azure secret to use for that client ID within the ansible playbook |

The user has a file (cd.yml) by environment to configure these properties, for example:

``` bash
📂.gluon
┗ 📂cd
   ┗ 📂cert
      ┗ 📜cd.yml
   ┗ 📂pre
   ┗ 📂pro
```

``` bash
- ci_id: CI00000000001
  extra_params:
    - ARTIFACT_REPOSITORY_URL: ${ARTIFACT_REPOSITORY_URL}
    - ENVIRONMENT: DEV
  extra_secret_params:
    - id: AZ_CLIENT_ID
      variable: AZURE_CLIENT_ID
    - id: AZ_CLIENT_SECRET
      variable: AZURE_CLIENT_SECRET
  ansible_debug: false
```

with no mandatory parameters defined:

``` bash
- ci_id: CI00000000001
  extra_params:
    - ARTIFACT_REPOSITORY_URL: ${ARTIFACT_REPOSITORY_URL}
    - DEPLOYMENT_JSON_FILE: deploy.json
    - ENVIRONMENT: PRE
    - USERS_CONFIG_TYPE: local
    - USERS_CONFIG_SOURCE_fake: ./folder/config
  extra_secret_params:
    - id: AZ_CLIENT_ID
      variable: AZURE_CLIENT_ID
    - id: AZ_CLIENT_SECRET
      variable: AZURE_CLIENT_SECRET
    - id: BBDD_USERNAME
      variable: DS_PoC_USERNAME
    - id: BBDD_PASSWORD
      variable: DS_PoC_PASSWORD
  ansible_debug: true
```
