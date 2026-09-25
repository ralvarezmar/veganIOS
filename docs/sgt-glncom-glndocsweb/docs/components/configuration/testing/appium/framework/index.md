# Appium Documentation

## Introduction

<!--Appium introduction start-->

**Appium** is an open-source project and ecosystem of related software, designed to facilitate UI automation of many app platforms, including mobile (iOS, Android, Tizen), and more!

Appium aims to support UI automation of many different platforms (mobile, web, desktop, etc.).Not only that, but it also aims to support automation code written in different languages (JS, Java, Python, etc.).

In order to achieve this, Appium is effectively split into four parts:

- **Appium Core** - defines the core APIs
- **Drivers** - implement connectivity to specific platforms
- **Clients** - implement Appium's API in specific languages
- **Plugins** - change or extend Appium's core functionality

Therefore, in order to start automating something with Appium, you need to:

- Install Appium itself
- Install a driver for your target platform
- Install a client library for your target programming language
- (Optional) install one or more plugins

These are the basics! If you want to know more check the [**official documentation**](https://appium.io/docs/en/latest/quickstart/).

<!--Appium introduction end-->

## Changes in Gluon

The proxy properties have changed, it now recovers them from environment variables.
The following environment variables are used to get the values for the proxy: no_proxy, http_proxy and https_proxy.
They are used to set the following system properties: http.proxyHost, http.proxyPort, http.nonProxyHosts, https.proxyHost and https.proxyPort.

The capabilities for language, locale and noReset will no longer be sent, instead, they must be set by the developers in the testing repository as capabilities.

The version of Gradle has been upgraded from 7.X to 8.X, due to this change the following changes have been applied to the framework:

1. Kotlin has been upgraded from 1.5.3 to 1.6.0.
2. In src/app/plugins/build.gradle the *kotlinPluginOptions.experimentalWarning* lines have been removed.
3. In src/app/plugins/settings.gradle.kts the *enableFeaturePreview("VERSION_CATALOG")* line has been removed.
4. In src/settings.gradle the *enableFeaturePreview("VERSION_CATALOG")* line has been removed.

When using the workflow to execute ondemand tests there is not an option to upload the app to Saucelabs. That must be done using the ci/cd workflow.

## Related content

[Appium Documentation](https://appium.io/docs/en/latest/)

[Kotlin Documentation](https://kotlinlang.org/docs/home.html)

[Gradle Documentation](https://docs.gradle.org/current/userguide/userguide.html)

[Appium Journey](../journey/appium-testing-journey.md)

[Testing portal](../../../../../application/qatesting/testing/portal/testing-portal/index.md)
