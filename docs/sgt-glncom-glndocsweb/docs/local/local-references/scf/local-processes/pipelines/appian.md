---
title: SCF Appian Adaptation Guide
---

This page aims to assist in the migration of components that previously relied on the ALM Multicloud pipeline `pipelineForAppian` in Jenkins.
The guide focuses on the migration and adaptation of the GitHub repository files to comply with Gluon.
Full information about yo use this component template can be found in [documentation](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/).

## Create component in Gluon

When creating a component in Gluon it will automatically create a repository in `http://github.com` with the following naming convention: `acronym_company`**-**`acronym_application`**-**`short_name_component`.

- acronym-company: Length of 3 characters, this field comes from APM.
- acronym-application: Length of 7 characters, it will be requested in the application onboarding in Gluon.
- short-name-component Length of 16 characters, it will be requested when creating the component in Gluon.

In order to create the component go to your application in Gluon portal > Components > New Component and select `(SCF) Appian`.

When selecting the component to create, you will be prompted to enter the short-name-component and contact information for the maintainer.
The mandatory branch strategy for this template is *git flow*, which helps in managing the development workflow efficiently.
The *git-flow* branch strategy is explained indetail in [git-flow lifecycle](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/ansible-execute/#gitflow-lifecycle).

Once the component is created, it will appear in the component list of your application followed by the used template, a short description and links to the GitHub repository.

The repository is created with a branch named `init-branch` that will run a scaffolding workflow to set up all required branches, environments and configuration files.
This workflow is expected to run automatically, so the expected behaviour is to find everything correctly configured.

???+ info "Scaffolding workflow"

    In some cases the scaffolding workflow will not run automatically. To solve this go to the Actions section of the repository and run the workflow manually from the *init-branch.*

## Repository migration

When scaffolding is executed, the repository will have this structure in the `development` branch, which must be respected for the workflow to work correctly:

```bash
📂.github
 ┣ 📂workflows
 | ┣ 📜cd.yml
 | ┣ 📜ci.yml
 | ┣ 📜quality.yml
 | ┣ 📜release.yml
 | ┣ 📜security.yml
 | ┣ 📜update-component-workflow.yml
 | ┗ 📜version-validation.yml
 ┗ 📜CODEOWNERS
📂.gluon
 ┣ 📂ci
 | ┗ 📜properties.env
📜deployment.yaml
📜metadata.properties
📜pom.xml
```

You must take the source code of your component to the source repository in the `development` branch and pay attention to the following adaptations.

### Deployment.yaml

Your deployment.yaml file can be kept as the original one:

```yaml
environments:
  CERT:
    appianUrl: https://scfdev.appiancloud.com/suite/
    appianCredentialId: devAppianCredential
    gitUrl:
    propertiesPath: metadata.properties
    artifactUrl: ${ARTIFACT_NEXUS_URL}
    appianAdditionalOptions:
        proxyPort: 80
        proxyUrl: http://proxyapps.gsnet.corp
  PRE:
    appianUrl:
    appianCredentialId: testAppianCredential
    gitUrl: https://github.alm.europe.cloudcenter.corp/scq-hq-enews/enews-appian.git
    propertiesPath: Pre/metadata.properties
    artifactUrl: ${ARTIFACT_NEXUS_URL}
    appianAdditionalOptions:
        proxyPort: 80
        proxyUrl: http://proxyapps.gsnet.corp
  PRO:
    appianUrl:
    appianCredentialId: proAppianCredential
    gitUrl: https://github.alm.europe.cloudcenter.corp/scq-hq-enews/enews-appian.git
    propertiesPath: Pro/metadata.properties
    artifactUrl: ${ARTIFACT_NEXUS_URL}
    appianAdditionalOptions:
        proxyPort: 80
        proxyUrl: http://proxyapps.gsnet.corp
```

### Metadata.properties

Your metadata.properties file can be kept as the original one:

```txt
## ----------------------------------------------------------------------
## Instrucciones
##
## Todas las propiedades de este archivo están definidas como comentarios; tienen el símbolo almohadilla
## al principio de la línea que los hace inactivos.
##
## Las instrucciones y los títulos están marcados con dos símbolos
## de almohadilla (##).
##
## Al importar, se ignoran todas las propiedades definidas como comentarios y los
## valores correspondientes en el entorno de destino permanecen
## sin cambios.
##
## Para establecer o cambiar una propiedad al importar usando este archivo,
## elimine los comentarios de la propiedad borrando el símbolo de almohadilla del comienzo
## de su línea. A continuación, introduzca un valor para la propiedad después del signo
## igual (=) al final de ese archivo de personalización de importación.
##
## Si descomenta una propiedad, pero no proporciona un valor, el valor de
## esa propiedad se establecerá como nulo en el entorno de destino.
## Las propiedades que corresponden a la configuración de la consola de administración y requieren un valor
## se configurarán a su valor predeterminado en lugar de configurarse como nulas. Los valores
## predeterminados de las configuraciones pueden ser diferentes entre las versiones de Appian.
##
## Para forzar la sincronización de un tipo de registro, agregue una entrada al archivo en el formato siguiente
## recordType.<UUID>.forceSync=true
##
## Para forzar la importación de objetos sin cambios, agregue la siguiente línea en el archivo
## importSetting.FORCE_UPDATE=true
##
## Nota: No elimine nunca los símbolos de almohadilla doble (##) delante de las instrucciones
## y los títulos.
## ----------------------------------------------------------------------

## Constante: PI_CONS_ENVIRONMENT_SAVE
## Tipo: Booleano
##
## Los valores booleanos se deben especificar como el texto "TRUE" o "FALSE".
#content._a-0000e3bd-d8fc-8000-9ba4-011c48011c48_205309.VALUE=FALSE

## Constante: PI_CONS_MAIL_ENEWS_ADDRESS
## Tipo: Dirección de Correo electrónico
##
## La dirección de correo electrónico debe especificarse en el formato abc@example.com.
#content._a-0000e2c6-ed6e-8000-9ba2-011c48011c48_166830.VALUE=info_Dev@santanderconsumer-enews.com

## Constante: PI_CONS_MAIL_LOCALUNITYAPP
## Tipo: Dirección de Correo electrónico
##
## La dirección de correo electrónico debe especificarse en el formato abc@example.com.
#content._a-0000e4e4-b2f7-8000-9bac-011c48011c48_229805.VALUE=cristian.gomez@atos.net

## Constante: PI_CONS_URL_APPLICATION_SERVER
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e182-cb0b-8000-9ba2-011c48011c48_108534.VALUE=https://scfdev.appiancloud.com

## Constante: PI_CONS_URL_AWS_CANCELSUBSCRIPTION
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e232-afcd-8000-9ba2-011c48011c48_147548.VALUE=https://vnqx3jnxfb.execute-api.eu-central-1.amazonaws.com/dev/cancelSubscriptionDEV

## Constante: PI_CONS_URL_AWS_CREATEUSER
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e2c6-ed6e-8000-9ba2-011c48011c48_168254.VALUE=https://nlrzjaypki.execute-api.eu-central-1.amazonaws.com/dev/createUserDEV

## Constante: PI_CONS_URL_AWS_DOCUMENTDOWNLOAD
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e232-afcd-8000-9ba2-011c48011c48_147529.VALUE=https://psc32uoxab.execute-api.eu-central-1.amazonaws.com/dev/getAppianDocDEV

## Constante: PI_CONS_URL_DOWNLOAD_DOCUMENTS_WEBSERVICE
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e18f-e11f-8000-9ba2-011c48011c48_134107.VALUE=https://scfdev.appiancloud.com/suite/webapi/downloaddocument

## Constante: PI_CONS_URL_WEBSERVICECHECK
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e18f-e11f-8000-9ba2-011c48011c48_135605.VALUE=https://scfdev.appiancloud.com/suite/webapi/checkmail

## Constante: PI_CONS_WEBSERVICE_LOGIN_PASSWORD
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e182-cb0b-8000-9ba2-011c48011c48_108519.VALUE=Password4·.

## Constante: PI_CONS_WEBSERVICE_LOGIN_USERNAME
## Tipo: Texto
##
## Los valores de texto se mostrarán en Appian exactamente como se
## especifiquen aquí. No se recorta ningún espacio. Los valores no necesitan estar
## entre comillas dobles.
#content._a-0000e182-cb0b-8000-9ba2-011c48011c48_108513.VALUE=userMicroservicio
```

### Ci-config.groovy

Information from the file `ci-config.groovy` located at the root of the repository is transferred to the configuration file `properties.env` located in the `.gluon/ci/` folder.

![Ci Config](images/generic/ci-config.png)

Note that this is not a 1:1 migration and that there are new fields. Below is an example of `properties.env`:

- The fields `FORTIFY_PROJECT` and `SONAR_PROJECT_KEY` are automatically filled during the scaffolding process.
- It's important to define `ARTIFACT_NATIVE_COMPILATION` if it is a `-Pnative` type build of Maven.
- Select `MAVEN_VERSION` and `JAVA_VERSION` from the following versions:

Java versions:
"adoptopenjdk-8.0.442+6"
"adoptopenjdk-11.0.26+4"
"adoptopenjdk-17.0.14+7"
"adoptopenjdk-21.0.6+7.0.LTS"

```yaml
# Sonar parameters
SONAR_PROJECT_KEY=""

# Fortify parameters
FORTIFY_PROJECT=""

# JVM using to build the project
JAVA_VERSION="adoptopenjdk-17.0.8+7"
MAVEN_DEPLOY_ARGS=""

# Active native compilation
ARTIFACT_NATIVE_COMPILATION="false"
```

### Secrets Configuration

In order to have your artifact uploaded to Nexus `NEXUS_USERNAME` and `NEXUS_PASSWORD` must be added as repository secrets within the repository.
To do so, go to `Settings > Security > Secrets and variables > Actions` and add the following secrets at “Repository secrets” level.

It’s also necessary to set  `APPIAN_DEPLOYMENT_USERNAME` and `APPIAN_DEPLOYMENT_PASSWORD` as repository secrets.

![Ci Config](images/generic/nexus-credentials.png)
