---
title: Changed Santander Spring Boot Framework Sonar Profile
categories:
     - Back
date:
     created: 2025-09-03
tags:
     - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

We have updated the Sonar profile for the **Santander Spring Boot** framework, covering both microservices and libraries.
Previously, the code was validated using a profile based on Sonar Way; it has now been switched to the Silver Quality Gate.
This change aims to facilitate the migration from Arsenal and Darwin Spring Boot-based frameworks to the new **Santander Spring Boot** framework.

### Why Is This Important?

Ensuring a smooth and easy transition to the new **Santander Spring Boot** framework is one of our main goals. To simplify
this migration, we have unified the Sonar Profile used in the new **Santander Spring Boot** framework components so that
they now use the same Sonar Profile as the Arsenal and Darwin Spring Boot-based frameworks.

### How to Use This Feature?

All new **Santander Spring Boot** microservices and libraries created with Gluon will now use the new Sonar Profile. Please
note that existing components will continue using the Sonar Way-based Sonar Profile.
