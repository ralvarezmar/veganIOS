---
title: Selenium
hide:
  - toc
---

<!-- Selenium configuration start -->

To run web tests on ephemeral runners, it's necessary to deploy the browsers and Selenium on where the tests will be run. To do this,
the **.testingConfig/selenium/properties.yml** file located in the testing repository must be configured. The following information is defined
in this file:

!!! note

    Many information of this part is the same as that used to deploy microservices.

|**Variable**|**Required**|**Description**|**Example value**|
|---  |---  |---  |---  |
|**deployInfra**| true | This parameter determines whether you want to deploy the entire infrastructure or if there is already an infrastructure deployed on perform the tests. | true |
|**seleniumHost**| Only if **deployInfra** is false | Selenium hub url for an existing infrastructure. Make sure the connectivity between runner and your Selenium Hub is enabled| 'https://selenium-host:port' |
|**environments.name**| true | Name of the environment where to deploy. | dev, pre or pro |
|**environments.repo**| true | Hostname DNS without protocol of the registry where the selenium images are. | registry.global.ccc.srvb.can.paas.cloudcenter.corp |
|**environments.project**| true | Name of the registry project where the selenium images are. | gluon-alm |
|**environments.clusterApiServer**| true | Cluster api server url to communicate with APIs on deploy infrastructure. | 'https://cluster-api-server:port' |
|**environments.namespace**| true | Namespace where to deploy selenium hub inside cluster. | testing-namespace |
|**environments.credentialsId**| false (Use this or **user/pass**) | Name of the Github secret with the indicated cluster access token. | CREDENTIALS_TOKEN |
|**environments.credentialUserId**| false (Use this or **credentialsId**) | Name of the Github secret with the indicated cluster access user. | CREDENTIALS_USER |
|**environments.credentialPassId**| false (Use this or **credentialsId**) | Name of the Github secret with the access password to the indicated cluster. | CREDENTIALS_PASS |

???+ warning

    To use this configuration you must ensure that the cluster where the browse will be deployed has connectivity with the indicated Harbor (**repo**),
    by default **registry.global.ccc.srvb.can.paas.cloudcenter.corp**. If it is not possible to open connectivity between the entity's cluster and the default registry, a request must be opened to the Gluon team to deploy the images in the entity's registry. See [Ephemeral runners](../../initialstep.md#122-ephemeral-runners).

<!-- Selenium configuration end -->