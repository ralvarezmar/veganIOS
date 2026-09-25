<!-- WORKFLOWS CONFIGURATIONS FILES -->

<!-- CICD -->

<!-- cicd workflow configuration description start -->

Within the testing repository there is a folder for configuration files **.testingConfig/cicd**, where we can define different files ​​for the execution of tests of different components.

On the one hand, there is a **.testingConfig/cicd/global.yml** file where the default values ​​will be that will apply to all tests
executed from cicd. On the other hand, for each component a file can be configured that must have the same name as the component
repository (**.testingConfig/cicd/repository-component.yml**). This configuration will overwrite the values ​​of the global file, when
a test associated with the deployment of the indicated component is executed.

<!-- cicd workflow configuration description end -->

<!-- ONDEMAND -->

<!-- ondemand workflow configuration description start -->

Within the testing repository there is a configuration file **.testingConfig/ondemand/global.yml**, where we can define values ​​for the execution of tests.
This configuration will apply to any test that is performed from the test repository and, will only be overwritten by the values ​​passed in the inputs, in an execution of the testing repository github workflow.

<!-- ondemand workflow configuration description end -->

<!-- COMMON SNIPPETS -->

<!-- workflow configuration general note start -->
!!! note

    For more information about configuration params check [Testing configurations](../utilities/configurations.md).
<!-- workflow configuration general note end -->

<!-- workflow configuration specific note start -->
!!! note

    For specific information about framework configuration go to corresponding framework section on [Ondemand](../ondemand/index.md) or [CiCd](../cicd/index.md).
<!-- workflow configuration specific note end -->

<!-- workflow web configuration file start -->

``` yaml title="Configuration file" linenums="1"
tags: <Tags to determine which cases you want to execute>
devices: <List of browsers where to run the tests>
threads: <Number of execution threads>

email:
  enabled: <True for enable email report>
  addresses: <List of email addresses separated by ,>

extraArgs: <Extra arguments to concatenate in the test execution command>

report:

  ...
   hpAlm:
    enabled: <True for enable HP-ALM report>
    domain: <ALM Domain>
    project: <ALM Project>
    qcApplication: <Qc Application, by default is default>
    reportLevel: <Report Level, by default is Default>
    prefix: <Folder path prefix to the report, by default this value is empty>
  #The following secrets are mandatory: XRAY_CLIENT_ID, XRAY_CLIENT_SECRET
  #The host is not required because this is the default value, and this line can be deleted if the user wants
  xray:
    enabled: true
    host: https://xray.cloud.getxray.app
    projectKey: # Optional, overrides the project set in Gluon
    labels: [] # List of labels to be set to each execution separated by commas
    testPlanKey: # The Test Plan Key, must be already created
```

<!-- workflow web configuration file end -->

<!-- workflow mobile configuration file start -->

``` yaml title="Configuration file" linenums="1"
tags: <Tags to determine which cases you want to execute>

#Information for mobile tests
mobile:
  saucelabs:
    url: <Saucelabs url, can also be set as repository or organization variable SAUCELABS_HOST>
    # We also need to set the secrets SAUCELABS_USER and SAUCELABS_TOKEN
  device:
    #selecting-your-test-device>
    name: <name of the device as it appears on Saucelabs, can also be a regex using valid notation as indicated in this [link](https://docs.saucelabs.com/mobile-apps/automated-testing/appium/real-devices/).
    version: <version of the device. If the name is the ID of a real device this value will be ignored>
    os: <either *android* or *ios*>

email:
  enabled: <True for enable email report>
  addresses: <List of email addresses separated by ,>

extraArgs: <Extra arguments to concatenate in the test execution command>

report:
   hpAlm:
    enabled: <True for enable HP-ALM report>
    domain: <ALM Domain>
    project: <ALM Project>
    qcApplication: <Qc Application, by default is default>
    reportLevel: <Report Level, by default is Default>
    prefix: <Folder path prefix to the report, by default this value is empty>
```

<!-- workflow mobile configuration file end -->

<!-- workflow newman configuration file start -->

``` yaml title="Configuration file" linenums="1"
tags: <Tags to determine which cases you want to execute>

email:
  enabled: <True for enable email report>
  addresses: <List of email addresses separated by ,>

extraArgs: <Extra arguments to concatenate in the test execution command>

report:
  hpAlm:
    enabled: <True for enable HP-ALM report>
    domain: <ALM Domain>
    project: <ALM Project>
    qcApplication: <Qc Application, by default is default>
    reportLevel: <Report Level, by default is Default>
    prefix: <Folder path prefix to the report, by default this value is empty>
```

<!-- workflow newman configuration file end -->

<!-- workflow jmeter configuration file start -->

``` yaml title="Configuration file" linenums="1"
jmeterFileName: <Path to jmx file>
apdexTolerated: <Apdex tolerated threshold index>
apdexSatisfied: <Apdex satisfied threshold index>

email:
  enabled: <True for enable email report>
  addresses: <List of email addresses separated by ,>

extraArgs: <Extra arguments to concatenate in the test execution command>

report:
  hpAlm:
    enabled: <True for enable HP-ALM report>
    domain: <ALM Domain>
    project: <ALM Project>
    qcApplication: <Qc Application, by default is default>
    reportLevel: <Report Level, by default is Default>
    prefix: <Folder path prefix to the report, by default this value is empty>
```

<!-- workflow jmeter configuration file end -->

<!-- workflow web configuration table start -->

|**Variable**|**Description**|**Example value**|
|---  |---  |---  |
|**tags**| Tags to determine which cases you want to execute. To use multiple tags they must be separated by ; | tag1;tag2 |
|**devices**| List of browsers where to run the tests. Options: chrome, firefox, edge, backend | chrome;firefox;edge |
|**threads**| Number of execution threads | 1 |
|**email.enabled**| Flag to enabled email report. | true |
|**email.addresses**| List of email addresses separated by , | foo@example.com,foo2@example.com |
|**extraArgs**| Extra arguments to concatenate in the test execution command. |  |
|**report.hpAlm.enabled**| Flag to enabled HP-ALM report. | true |
|**report.hpAlm.domain**| ALM Domain where the report will be sent. | DOMAIN |
|**report.hpAlm.project**| ALM Project where the report will be sent. | PROJECT |
|**report.hpAlm.qcApplication**| Qc Application, by default is default. | default |
|**report.hpAlm.reportLevel**| Report Level, by default is Default. | Default |
|**report.hpAlm.prefix**| Folder path prefix to the report is saved, by default this value is empty. |  |

<!-- workflow web configuration table end -->

<!-- workflow mobile configuration table start -->

|**Variable**|**Description**|**Example value**|
|---  |---  |---  |
|**tags**| Tags to determine which cases you want to execute. To use multiple tags they must be separated by ; | tag1;tag2 |
|**mobile.saucelabs.url**| Saucelabs url | "https://ondemand.eu-central-1.saucelabs.com:443" |
|**mobile.device.name**| Name of the device as it appears on Saucelabs or valid regex notation as explained in this [link](https://docs.saucelabs.com/mobile-apps/automated-testing/appium/real-devices/). | Samsung Galaxy Tab S7 Plus GoogleAPI Emulator |
|**mobile.device.version**| Version of the device. Must be set as string. | "15.0" |
|**mobile.device.os**| The operative system of the device | android or ios |
|**email.enabled**| Flag to enabled email report. | true |
|**email.addresses**| List of email addresses separated by , | foo@example.com,foo2@example.com |
|**extraArgs**| Extra arguments to concatenate in the test execution command. |  |
|**report.hpAlm.enabled**| Flag to enabled HP-ALM report. | true |
|**report.hpAlm.domain**| ALM Domain where the report will be sent. | DOMAIN |
|**report.hpAlm.project**| ALM Project where the report will be sent. | PROJECT |
|**report.hpAlm.qcApplication**| Qc Application, by default is default. | default |
|**report.hpAlm.reportLevel**| Report Level, by default is Default. | Default |
|**report.hpAlm.prefix**| Folder path prefix to the report is saved, by default this value is empty. |  |

<!-- workflow mobile configuration table end -->

<!-- workflow newman configuration table start -->

|**Variable**|**Description**|**Example value**|
|---  |---  |---  |
|**tags**| Tags to determine which cases you want to execute. To use multiple tags they must be separated by ; | tag1;tag2 |
|**email.enabled**| Flag to enabled email report. | true |
|**email.addresses**| List of email addresses separated by , | foo@example.com,foo2@example.com |
|**extraArgs**| Extra arguments to concatenate in the test execution command. |  |
|**report.hpAlm.enabled**| Flag to enabled HP-ALM report. | true |
|**report.hpAlm.domain**| ALM Domain where the report will be sent. | DOMAIN |
|**report.hpAlm.project**| ALM Project where the report will be sent. | PROJECT |
|**report.hpAlm.qcApplication**| Qc Application, by default is default. | default |
|**report.hpAlm.reportLevel**| Report Level, by default is Default. | Default |
|**report.hpAlm.prefix**| Folder path prefix to the report is saved, by default this value is empty. |  |

<!-- workflow newman configuration table end -->

<!-- workflow jmeter configuration table start -->

|**Variable**|**Description**|**Example value**|
|---  |---  |---  |
|**jmeterFileName**| Path to jmx file name you want to execute. File must have .jmx extension | ./path/to/file.jmx |
|**apdexTolerated**| Apdex tolerated threshold index | 1800 |
|**apdexSatisfied**| Apdex satisfied threshold index | 600 |
|**email.enabled**| Flag to enabled email report. | true |
|**email.addresses**| List of email addresses separated by , | foo@example.com,foo2@example.com |
|**extraArgs**| Extra arguments to concatenate in the test execution command. |  |
|**report.hpAlm.enabled**| Flag to enabled HP-ALM report. | true |
|**report.hpAlm.domain**| ALM Domain where the report will be sent. | DOMAIN |
|**report.hpAlm.project**| ALM Project where the report will be sent. | PROJECT |
|**report.hpAlm.qcApplication**| Qc Application, by default is default. | default |
|**report.hpAlm.reportLevel**| Report Level, by default is Default. | Default |
|**report.hpAlm.prefix**| Folder path prefix to the report is saved, by default this value is empty. |  |

<!-- workflow jmeter configuration table end -->

<!-- workflow configuration extraArgs start -->

The configuration files offer the possibility for the user to add extra commands to the test execution command.
This functionality is under the responsibility of the user, who must be sure that the command they are adding is valid for
the technology they are working with.

<!-- workflow configuration extraArgs end -->
