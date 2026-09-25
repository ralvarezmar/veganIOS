# How to set up the smoke test

The smoke test (***smoke test***) also known as **Build Verification Test** or **Confidence Test** verifies that the important features of the application are working, in a nutshell.

It is a **mini and quick acceptance test** that shows in a simple way if the product is ready and available.

One of the most common ways to validate that the application is available is to verify that the title of the ***deployed*** page is the same as the title configured on the ***index.html*** page of our application.

As an example, we will use the ***index.html*** of the portal:

``` HTML
<!doctype html>
<html lang="pt-br">
<head>
  <meta charset="utf-8">
  <title>AFE PORTAL (Front-End Architecture)</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
  <afe-root></afe-root>

</body>
</html>
```

In this case, the ideal smoke test is to check if there is an occurrence of "Portal AFE (Front-End Architecture)" in the application that has just been deployed, and if it does not find it, the test should fail.

In order to configure the treadmill so that it takes our application title as an argument, we need to change the ***args*** property of the ***smokeTest*** within the ***./ci/conf.yml*** file to the value set as the application title:

``` YML
 smokeTest:
    type: SCRIPT_SHELL
    repository: N/A
    branch: N/A
    args: Portal AFE (Arquitetura de Front-End)
```

> The configuration of ***Smoke Test*** is divided by environment in the ***conf.yml***, and it is possible to configure: ***dev, pi, pre and blue*** (production hidden), however, the values remain the same.
