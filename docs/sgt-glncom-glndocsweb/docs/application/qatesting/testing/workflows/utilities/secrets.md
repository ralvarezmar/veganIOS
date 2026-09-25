---
title: Secrets
hide:
  - toc
---

## **Use secrets in testing workflows**

When running tests through workflows we can use Git secrets in the tests. To do this, you can add a list with the names of the secrets
that you want to use in the .testingConfig/secrets.yml file. It must be taken into account that in order to recover the values ​​of these
secrets, they must exist as repository or organization secrets ([See how to create a new secret](../../../../ci-cd/howtos/index.md#2-secrets-in-githubcom)).
Once the workflow reads the list of secrets that you want to use, they will be sent to the execution command of the corresponding framework
so that they can be used during the execution of the test.

``` yaml title=".testingConfig/secrets.yml" hl_lines="13 14" linenums="1"
-   SECRET_1
-   SECRET_2
```

Once the secrets are configured in the file and created as Github secrets of the repository or organization, these will be passed
to the test execution command as environment variables. Depending on the framework used, the secret will be passed as follows:

- **Newman:** --env-var SECRET_KEY=SECRET_VALUE
- **Jmeter:** -JSECRET_KEY=SECRET_VALUE
- **Nitro:** -DSECRET_KEY="SECRET_VALUE"
- **Cilantrum:** -DSECRET_KEY="SECRET_VALUE"
- **Talos:** export SECRET_KEY=SECRET_VALUE
- **Appium:** -DSECRET_KEY="SECRET_VALUE"

During a workflow execution, on the logs, the secrets will be obfuscated. Instead of showing as a list of pairs key-value as seen above it will only display ***.

Check the framework documentation to know how to use environment variables.
