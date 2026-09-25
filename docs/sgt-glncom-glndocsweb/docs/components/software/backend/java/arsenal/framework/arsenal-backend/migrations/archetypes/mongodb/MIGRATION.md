# Migration Guide

    All notable versions to project `gln-back-arsenal-backend-archetype-mongodb` will be documented in this file.

## Version 3.9.3

<!tag:393>

  To ensure our achetypes are effective, we've increased test coverage, fixed sonar issues and update SpringBoot version

<!end:393>

## Version 3.8.0

<!tag:380>

  In this version we make some corrections and upgrades:

* Refactor of Template form for gluon portal
* Fortify and Sonar issues
* Version upgrades
* Import SQL script corrections for test databases

<!end:380>

## Version 3.7.1

<!tag:371>

  So that users can view the status of their applications, we added Health Check Custom Configurations to our archetypes

<!end:371>

## Version 3.6.2

<!tag:362>

 We change deprecated parameters, impacting parameter names. After updating the framework version, you will need to replace the parameters:

* `max-http-header-size` replace to `max-http-request-header-size` and `tomcat.max-http-response-header-size`
* `spring.datasource.continue-on-error` replace to `sql.init.continue-on-error`
* `spring.datasource.platform` replace to `replace to sql.init.platform`

  We also translated archetype-resource Readme.md and project Readme.md from portuguese to english.

<!end:362>

## Version 3.4.3

<!tag:343>

  We have added fields in the archetype application.yml file that users can define which company, component and application on the Gluon Platform they want to see logs to observe the behavior.
**This parameters is mandatory, if they are not configured the application will not run**

<!end:343>

## Version 3.4.2

<!tag:342>

  We added a conditional to our archetype so that the user can choose between two error staters, gluon error stater or default error stater

<!end:342>
