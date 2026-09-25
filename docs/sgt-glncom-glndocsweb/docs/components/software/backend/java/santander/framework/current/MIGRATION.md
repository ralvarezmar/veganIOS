# SANTANDER SPRING BOOT MIGRATION GUIDE ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Introduction

This Guide will provide the necessary steps to successfully migrate your Santander Spring Boot project from an older version to a higher one.

Depending on the version and on the upgrade needed on your project, it is recommended to follow some different guidelines to help you achieve your target.

## How to upgrade to a Minor/Patch version

For minor or patch version migrations the backwards compatibility is guaranteed, so in order to update one of these versions, we recommend to
manually upgrade the Santander Spring Boot Parent version of the pom.xml in your project.

## How to upgrade to a Major version

For major version migrations, we highly recommend to use Santander Spring Boot Migration Assistant which can be added as a plugin that will execute a series of OpenRewrite recipes in your project,
automatically updating it to the Santander Spring Boot version requested or to the latest version. This can be manually configured in the plugin.

It is possible to find much more information about this tool and how to configure it in
the [Santander Spring Boot Migration Assistant Guide](https://gluon.gs.corp/community/docs/latest/components/software/backend/java/santander/framework/how-to-guides/darwin-spring-boot-to-santander-framework/)

## Migration details

In case you need to check the migration changes and references, you can find a detailed list in the following link to the [Migration Detail List](MIGRATION-DETAILS.md)
