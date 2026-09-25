---
title: Supra Deployment Journey
---

## Introduction

The purpose of this documentation is to indicate the specific parameters to the SUPRA deployment's.

These parameters will be specified by the user in the cd.yml files of each of the environments that he wishes to deploy.

## How to configure your deployment environment

The SUPRA deployment is orchestrated via Ansible, so the applicable parameters will be those specific to ANSIBLE.

{!
   include-markdown "../../technologies/maven/snippets/snippet-oam-artifact.md"
   start="<!--Start Infrastructure 2.0-->"
   end="<!--End Infrastructure 2.0-->"
!}

## Extra SUPRA specific parameters

#### **extra_params**

| Key                    | Description                                                        | Example                                                                 |
| -------------          | ------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| `artifact_url`                 | Artifact URl                                              | ${ARTIFACT_REPOSITORY_URL}                                                              |
| `target`         | Target machine  | isblcncldrp0003          |
| `deploy`         | Deployment type, values: onpremise (default)/cloud  | onpremise          |
| `environmentFile`         | Environment properties file  | environment-canary-CER.properties          |
| `environmentFileGit` | Github repository (organization/repository) where the environment properties file is downloaded. If the parameter is not defined, the environment properties file is obtained from the Github inventory project  | gln-organization/gln-alm-supra-environment   |
| `environmentFileGitVersion`         | Version (branch or tag) of github repository where the environment properties file is downloaded. By default 'main'  | v1.0.0         |
| `keeptempdir`         | Debug variable to maintain the temporary path on the target machines,values: false(default)/true  | false          |

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
- ci_id: CI0000000001312-supra

  extra_params:

    - artifact_url: ${ARTIFACT_REPOSITORY_URL}

    - target: isblcncldrp0003

    - deploy: onpremise

    - environmentFile: environment-canary-CER.properties

    - keeptempdir: false
```

with environment github repository defined:

``` bash
- ci_id: CI0000000001312-supra

  extra_params:

    - artifact_url: ${ARTIFACT_REPOSITORY_URL}

    - target: isblcncldrp0003

    - deploy: onpremise

    - environmentFile: environment-canary-CER.properties

    - environmentFileGit: gln-organization/gln-alm-supra-environment

    - environmentFileGitVersion: v1.0.0

    - keeptempdir: false
```

#### **extra_secret_params**

Secrets obtained from github and converted into environment variables for use
within the ansible playbook or the environment file. This parameter is a list of:

- id: id of the github secret
- variable: name of the environment variable to create and use in the ansible playbook

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
- ci_id: CI0000000001312-supra
  extra_params:
    - artifact_url: ${ARTIFACT_REPOSITORY_URL}
    - target: isblcncldrp0003
    - deploy: onpremise
    - environmentFile: environment-canary-CER.properties
    - keeptempdir: false
  extra_secret_params:
    - id: POSTGRES_CANARIO_PASSWORD_ID
      variable: POSTGRES_CANARIO_PASSWORD
```

The file environment, for example:

``` bash
# bbdd configuration
sql_password=$POSTGRES_CANARIO_PASSWORD
```
