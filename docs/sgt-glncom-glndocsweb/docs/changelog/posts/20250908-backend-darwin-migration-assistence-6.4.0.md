---
title: Released Darwin Migration Assistance 6.4.0
categories:
     - Back
date:
     created: 2025-09-08
tags:
     - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

We have released a new version **6.4.0** of the **Darwin Migration Assistant**.
This version includes the following [changes](../../components/software/backend/java/darwin/framework/migration-assistant/changelog.md#v640).

### Why Is This Important?

This version includes a new recipe to migrate to **Santander Spring Boot Framework**.

### How to Use This Feature?

To upgrade an application to version 1.X of Santander Framework you have to execute the next command:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipes=com.santander.darwin.migrationassistant.UpgradeToSantanderFramework
```

!!! note

    To make the migration successfully, the minimum version used of **Darwin Spring Boot** must be `6.3.0`.

!!! tip

    This migration guide is valid for migrating both Darwin Spring Boot Microservices and Darwin Spring Boot Libraries.

More information about [Migration Assistant](../../components/software/backend/java/darwin/framework/migration-assistant/index.md).
