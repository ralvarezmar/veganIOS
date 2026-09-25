# Migration Guide

    All notable versions to project `gln-back-arsenal-backend-archetype` will be documented in this file.

## Version 3.9.3

<!tag:393>

  To ensure our archetypes are effective, we've increased test coverage, fixed sonar issues and update SpringBoot version

<!end:393>

## Version 3.8.0

<!tag:380>

  In this version we make some corrections and upgrades:

- Refactor of Template form for gluon portal

- Fortify and Sonar issues
- Version upgrades
- Import SQL script corrections for test databases

<!end:380>

## Version 3.7.1

<!tag:371>

  So that users can view the status of their applications, we added Health Check Custom Configurations to our archetypes

<!end:371>

## Version 3.6.2

<!tag:362>

 We change deprecated parameters, impacting parameter names. After updating the framework version, you will need to replace the parameters:

- `max-http-header-size` replace to `max-http-request-header-size` and `tomcat.max-http-response-header-size`

 We also translated archetype-resource Readme.md and project Readme.md from portuguese to english.

<!end:362>
