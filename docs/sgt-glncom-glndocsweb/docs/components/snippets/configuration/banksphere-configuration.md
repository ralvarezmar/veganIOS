### Branches
<!--Start TBD Branches-->

#### Trunk Based Development

Here, Gluon works with only one branch that will need to be incorporated into our project:

- The main branch (main by default or master in old projects)

With trunk-based development, we will merge feature branches with Pull Requests directly into the main branch.
<!--End TBD Branches-->

### Configuration Files
<!--Start Configuration Files-->
- **properties.env**: Properties with the CI configuration
<!--End Configuration Files-->

#### Properties
<!--Start Common Properties-->
The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
**The mandatory parameters that must be configured are**:

| Property | Required | Description | Example value |
|--|--|--|--|
| **BKS_VRF** | true | Functional version of Banksphere assembly product (PSI) | V01R02F16 |
| **BKS_TBLPARAM** | true | Version or URL of Tabla de Parámetros component | <https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.55.0.zip> |
| **CLIENT** | true | Release recipient client | SANTANDER |
| **BKS_CERTIFICATION_ENVIRONMENT** | true | Name of the certification environment where to deploy Banksphere assembly | CERT_BKS_PAAS |

???+ info "Available clients"

    The available clients to set in the CLIENT property are:

        GSC
        OPENBANK
        SAN
        SANGO
        SANTANDER
        SANTANDERCORPBANKINGUK
        SANTANDERGERMANY
        SANTANDERUK
        SGT
        TOTTA
        SOVEREIGN
        SANTANDERMEXICO
        SCIB
        NNGG
        BRASIL

    ***For clients not shown in the list above****, you must set* **`SNAPSHOTS`** *in the CLIENT property and follow the HADA DTSSGS current circuit, this means manually sending the documentation for your new publication to the client.*

???+ info "Clients Harbor projects"

    Harbor projects where images will be uploaded in the release workflow per client:

    | Client | Harbor project |
    |--|--|
    | GSC | bks-apps-gsc |
    | OPENBANK | bks-apps-opb-sgt |
    | SAN | bks-apps-santander-san |
    | SANGO | bks-apps-sango |
    | SANTANDER | bks-apps-spain |
    | SANTANDERCORPBANKINGUK | bks-apps-corporateuk |
    | SANTANDERGERMANY | bks-apps-germany-scg-sgt |
    | SANTANDERUK | bks-apps-retailuk |
    | SGT | bks-apps-sgt |
    | TOTTA | bks-apps-tot |
    | SOVEREIGN | bks-apps-usa-sgt |
    | SANTANDERMEXICO | bks-apps-mx-sgt |
    | SCIB | bks-apps-scib-sgt |
    | NNGG | bks-apps-scib-sgt |
    | BRASIL | bks-apps-bra-sgt |

???+ info "Available certification environments"

    The available environments to set in the BKS_CERTIFICATION_ENVIRONMENT property are:

        CERT_BKS_PAAS
        CERT_BKS_PAAS_BRA
        CERT_BKS_PAAS_CHI
        CERT_BKS_PAAS_GER
        CERT_BKS_PAAS_GLOBAL
        CERT_BKS_PAAS_MEX
        CERT_BKS_PAAS_OPB
        CERT_BKS_PAAS_SAN
        CERT_BKS_PAAS_UK
        CERT_BKS_PAAS_UKRETAIL
        CERT_BKS_PAAS_USA

??? info "Optional properties"

    Below are the properties that the user can set up in the
    **`properties.env`** file within their GitHub project. All these properties
    are optional. If not set, the default value will be used.

    | Property | Required | Description | Default | Example value |
    |--|--|--|--|--|
    | PSI | false | SGS Package Software Id (PSI) to create image. | *the latest PSI in DEV state* | 1277146 |
    | BKS_ARQ_GITBRANCH | false | Branch or tag for the BKS self-contained image build scripts (dockerfile). | main | V02R25F54 |
    | BKS_BASE_IMAGE | false | BKS Liberty Docker image base name. | registry.global.ccc.srvb.can.paas.cloudcenter.corp/produban/bks-liberty | registry.global.ccc.srvb.can.paas.cloudcenter.corp/produban/bks-liberty |
    | BKS_BASE_VERSION | false | BKS Runtime version. | release | release |
    | BKS_GLOA | false | Global Arch version PSI. Possible products: *GLOBAL_ARQ* or *GLOBAL_ARQATM*. | *The latest released version of GLOBAL_ARQ* | 1062336 |
    | BKS_GLOU | false | Global Usa version PSI. Possible products: *GUESTD_GESTANDARD*, *GLOBAL_USA* or *GLOBAL_STD*. | *The latest released version of GLOBAL_USA* | 1096582 |
    | BKS_HOTFIXES | false | Banksphere hotfix. |  |  |
    | BKS_EXTERNAL_LIBS | false | Banksphere external libraries. |  |  |
    | CONTAINER_BUILD_ARGS | false | Additional image build arguments. |  | "--build-arg arg1=value1 --build-arg arg2=value2" |
    | CONTAINER_LABELS | false | Additional image labels |  | "--label label1=value1 --label label2=value2" |
    | BKS_JAVA_OPTIONS | false | Banksphere java options. |  | "-XX:InitialRAMPercentage=20" |
    | BKS_ASSEMBLY_LOGS_LEVEL | false | It will contain the url of a file with which the scripts will then overwrite the assembly's functional log configuration (which is stored in the assemblyLogsLevels.xml file in the release). |  |  |

??? info "Available GlobalTblParams"

    | Version | URL | 
    |--|--|
    | 14.55.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.55.0.zip |
    | 14.56.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.56.0.zip |
    | 14.57.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.57.0.zip |
    | 14.58.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.58.0.zip |
    | 14.59.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.59.0.zip |
    | 14.60.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.60.0.zip |
    | 14.61.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.61.0.zip |
    | 14.62.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.62.0.zip |
    | 14.63.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.63.0.zip |
    | 14.64.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.64.0.zip |
    | 14.65.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.65.0.zip |
    | 14.66.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.66.0.zip |
    | 14.67.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.67.0.zip |
    | 14.69.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.69.0.zip |
    | 14.70.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.70.0.zip |
    | 14.72.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.72.0.zip |
    | 14.73.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.73.0.zip |
    | 14.74.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.74.0.zip |
    | 14.75.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.75.0.zip |
    | 14.76.0 | https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/SGT/JAVA_NOMAVEN/sgt-servqa/Tablas_Parametros_BKS/GlobalesTblParam/GlobalesTblParam-14.76.0.zip |

??? info "Available Global Architecture"

    Latest published versions (default in **bold**).

    | PSI | SGS Publication | 
    |--|--|
    | 1229500 | GLOBAL_ARQ_V37R01F90_E6B13.1653244 |
    | 1213584 | GLOBAL_ARQ_V37R01F89_E5B6.1643114 |
    | 1212283 | GLOBAL_ARQ_V37R01F88_E4B5.1642285 |
    | 1121600 | GLOBAL_ARQ_V37R01F87_E1B1.887615 |
    | 1062336 | GLOBAL_ARQ_V36R07F86_E7B9.620583 |
    | 1049535 | GLOBAL_ARQ_V36R07F85_E6B8.608237 |
    | 1039072 | GLOBAL_ARQ_V36R07F84_E5B5.590610 |
    | 1036714 | GLOBAL_ARQ_V36R07F83_E4B4.588724 |
    | **632475** | **GLOBAL_ARQ_V36R04F70_E3B11.5139@\pvBKSARQ** |

??? info "Available Global Usability"

    Latest published versions (default in **bold**).

    **GUESTD_GESTANDARD**:

    | PSI | SGS Publication | 
    |--|--|
    | 1277510 | GUESTD_GEST_V01R01F106_E147B173.1676867 |
    | 1265628 | GUESTD_GEST_V01R01F105_E146B172.1671335 |
    | 1261963 | GUESTD_GEST_V01R01F104_E143B171.1669280 |
    | 1259758 | GUESTD_GEST_V01R01F103_E142B170.1668328 |
    | 1257721 | GUESTD_GEST_V01R01F102_E141B169.1667570 |
    | 1247409 | GUESTD_GEST_V01R01F101_E134B160.1662780 |
    | 1241628 | GUESTD_GEST_V01R01F100_E130B156.1659858 |

    **GLOBAL_USA**:

    | PSI | SGS Publication | 
    |--|--|
    | 1231311 | GLOBAL_USA_V04R01F451_E28B53.1654606 |
    | 1212162 | GLOBAL_USA_V04R01F450_E27B52.1642225 |
    | 1209962 | GLOBAL_USA_V04R01F449_E26B51.1641092 |
    | 1209225 | GLOBAL_USA_V04R01F448_E25B50.1640650 |
    | 1201795 | GLOBAL_USA_V04R01F447_E24B49.1635784 |
    | 1197563 | GLOBAL_USA_V04R01F446_E22B47.1633498 |
    | 1186547 | GLOBAL_USA_V04R01F445_E20B39.1627562 |
    | **636353** | **GLOBAL_USA_V03R12F368_E290B440.4361@\pvBKSARQ** |

    **GLOBAL_STD**:

    | PSI | SGS Publication | 
    |--|--|
    | 658998 | GLOBAL_STD_V01R00F07_E21B33.6832@\pvBKSARQ |
    | 591583 | GLOBAL_STD_V01R00F06_E20B26.4980@\pvBKSARQ |
    | 585467 | GLOBAL_STD_V01R00F05_E19B25.1663@\pvBKSARQ |
    | 543887 | GLOBAL_STD_V01R00F04_E16B22.9150@\pvBKSARQ |
    | 411909 | GLOBAL_STD_V01R00F00_E1B1.747@\pvBKSARQ |
    | 1239949 | GUESTD_GEST_V01R01F99_E129B155.1658977 |

<!--End Common Properties-->

#### Continuous Deployment files
<!--Start Deployment-->
In that set of files,
we are going
to define the necessary infrastructure references
so that the helm chart can deploy the configmap correctly in the configured environment.
The Continuous Deployment file (`cd.yml`) must
contain the target deployment configuration that we want to use for deploying the component.
For each environment (cert),
we have a folder with the `cd.yml` file, and there,
we can define the infrastructure to deploy.
Remember that `cd.yml` files are empty,
and the developer is responsible for filling them with the necessary deployment information.

``` bash
📂.gluon
┣ 📂cd
┃ ┣ 📂cert
┃ ┃ ┗ 📜cd.yml
```

For that purpose,
it will only be necessary to add the `ci_id` identifiers
defined by environment type in the `oam-application-definition.yml` file inside **Gluon Open Application Model repository**
associated with the company of the component.
Keep in mind that **`ci_id` must be the same as we have in OAM the config file**.
The `configuration_files` key allows
setting the `values` chart files that they are necessary to be able
to deploy in the infrastructures to which they refer.

| Property | Description | Example |
|--|--|--|
| ci_id | Identifier of the infrastructure in the oam-application-definition.yml file | CI00000000097 |
| configurationFiles | Path to the Helm configuration file in that environment | .gluon/cd/cert/values-cert.yml |

The following template shows an example of the structure that the `cd.yml` file should have:

```yaml
# Kubernetes cluster in Openshift
- ci_id: CI00000000001
  configuration_files:
    - .gluon/cd/values.yml
```

[See the full list of examples of how to set up your deployment infrastructure here](../../software/banksphere/snippets/oam-configuration.md)

For getting more information about how-to-configure the deployment environment files,
please refer to the [Continuous Deployment file documentation](../../../application/ci-cd/cd/cd-rm/cd-workflow/cd-envs-configuration.md).

For getting
to know
how to configure the `Gluon Open Application Model` repository,
the following documentation is available [here](../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-config.md)

<!--End Deployment-->
