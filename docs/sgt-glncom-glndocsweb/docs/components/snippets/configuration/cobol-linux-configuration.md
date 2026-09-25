### Branches
<!--Start GFW Branches-->
Gluon works with two branches that will need to be incorporated into our project:

- The main branch (main by default)
- The integration branch (development by default)

This is because the workflows works with GitFlow strategy, so we need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.
<!--End GFW Branches-->

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
| **CLIENTS** | true | List of customers (separated by commas, without white spaces) where we are going to send the software when the release is publish to SGS. | Santander,NNGG |

???+ info "Available clients"

    The available clients to set in the CLIENT property are:

        Abbey
        Alemania 
        AreasCorp
        Brasil
        GEMoney
        HUB
        Isban
        NNGG
        Santander
        SantanderChile
        SantanderConsumerES
        SantanderConsumerHQ
        SantanderMexico
        SCU
        Sovereign
        Totta
        Wealth

??? info "Optional properties"

    Below are the properties that the user can set up in the
    **`properties.env`** file within their GitHub project. All these properties
    are optional. If not set, the default value will be used.

    | Property | Required | Description | Default | Example value |
    |--|--|--|--|--|
    | JAVA_HOME | false | Path to custom JAVA_HOME | /DATOS/jdk1.8.0_60 | /pgm/java/jdk_1.8.1_64 |
    | SONAR_TIMEOUT | false | Sonar timeout in minutes | 15 | 60 |

<!--End Common Properties-->