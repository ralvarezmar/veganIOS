# Equalization of test environments

The equalization of environment allows you to simulate the environment in which the pipeline is running the project's unit tests, directly on your computer.

This practice allows for more efficient corrections when a problem that occurs on the pipeline cannot be reproduced in a local environment.
And the procedure only makes sense if it identifies that the version of _**Chrome Headless**_ run on the pipeline is different from the version when run locally.

> Attention!
>
> This documentation should only be used to simulate the conveyor unit test environment in inconsistency scenarios. Use only for debugging and fixing!
>
> After the issues are resolved, reverse the equalization!

Follow the steps below to equalize the test environment of your machine with that of the belt:

## 1. Delete the _**node_modules**_ folder

```bash
rm -fdr node_modules
```

> If you're using Windows, run the above command from Git Bash.

## 2. Equalize the **.npmrc** files from the pipeline and locally

To simulate the test environment run on the pipeline by _**puppeteer**_, you will need to update some variables in the **.npmrc** file of the project root with the one used by the pipeline (located in the **.ci/files** folder).

### 2.1 Update the _PUPPETEER_SKIP_CHROMIUM_DOWNLOAD_ variable

Update the **_PUPPETEER_SKIP_CHROMIUM_DOWNLOAD_** variable in the **.npmrc** file that is at the root of the project so that it sees the value as **false**, as this will make sure that the Chromium download step is not skipped.

```diff
- PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
+ PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false
```

> 💡 Curiosity
>
> In development mode, the **_PUPPETEER_SKIP_CHROMIUM_DOWNLOAD_** variable is added so that the Chromium binary is not installed. In this way, the browser already installed on your computer will be used to carry out the project tests.

### 2.2. Check the **puppeteer** settings in the **.npmrc** file

If the **.npmrc** file in the **.ci/files** folder contains the **puppeteer_chromium_revision** variable setting.

Then running the tests on the conveyor belt is using a specific version of _**Chrome Headless**_ based on the **_Chromium version_**, instead of using the one that **_puppeteer_** will load based on its version.

If this is the scenario, to have locally guaranteed equalization of the version of Chrome Headless that the pipeline is running, equalize the **.npmrc** file of the pipeline with the one of the root of your project, configuring:

- The **puppeteer_download_host** variable with the location from which the _**Chromium will be downloaded**_
- The **puppeteer_chromium_revision** variable with the same version used in the **.npmrc** of the **.ci/files** folder

As an example, the root of your project should include the following variables.

```conf
+ puppeteer_download_host=http://artifactory.santanderbr.corp/artifactory/github-puppeteer/
+ puppeteer_chromium_revision=<numero-de-revision-igual-a-do-npmrc-da-pasta-ci-files>
```

## 3. Use the **puppeteer** directly in the **karma.conf.js** file

To simulate the pipeline environment, you need to use the [**puppeteer**](https://pptr.dev/) library directly with Karma, instead of the browser installed on your computer.

Change the **karma.conf.js** file as per the code below.

```diff
- const process = require('process');
- if (process.platform !== 'win32' && process.platform !== 'darwin') {
-    process.env.CHROME_BIN = process.env.CHROME_BIN || require('puppeteer').executablePath();
- }
+ process.env.CHROME_BIN = require('puppeteer').executablePath();
```

> If your project is of type _**Element**_, apply this change _also_ to the **karma.conf.js** file of that project.

## 4. Install project dependencies

Install project dependencies so that the changes you make are applied correctly to the project.

```bash
npm install
```

During the execution of the dependency installation command, observe the log recorded in the terminal, evaluating if after **puppeteer** is installed, a postinstall process that downloads the _**Chromium**_ binary is executed.

> Another way to validate that the expected download was actually done is to access the **node_modules**, navigate to the **puppeteer** dependency and check if the folder associated with _**Chromium**_ is listed.

## 5. Analyze the execution of the unit tests after the equalization performed

Finally, run the command for the **_test_** script, ensuring that after the adjustments are made, the version of **_Chrome Headless_** that is being run the tests is the same version used on the pipeline.

Then, based on the test results, it is possible to validate if the problem occurs due to the version of the **_Chrome Headless_** used by the pipeline that is different from the version loaded by the **_Chrome_** installed on your machine.

**If the tests complete successfully**, then the failure is unrelated to the version of **_Chrome Headless_** and possibly the problem is related to the implementation of the unit tests themselves.

## Revert **ALL OF THE ABOVE CHANGES** after troubleshooting the issues

Revert **all of these changes** after fixing the pipeline-related issues.

Room equalization should only be used to **simulate problems**, and not as a default development environment.

**Related Issues:**

[How to solve the "Please set env variable CHROME_BIN" issue](./chrome-bin.md)
