# Sonar Exclusions

When passing a **SPA** or **NODE** project through the ***devOps*** conveyor belt, you will be asked for some information regarding your project's settings, one of them being the ***sonarExclusions*** property.

Which informs you which files will not be validated by **sonarQube**.

The types of files that fall into this category are:

- interfaces (***\*.model.ts***, ***\*.interfaces.ts***);
- configuration files (***\*.config.ts***);
- test files (***\*.spec.ts***,); - Test and dependencies coverage folder (***coverage***, ***node_modules***);
- type definition files (***\*\*/\*.d.ts***);

## IC Configuration

Add the **sonarExclusions** property of the **.ci\conf.yml** file with the following values:

``` TS
sonarExclusions: '**/tsconfig.*,**/dist/**,**/node_modules/**,**/coverage/**,**/*.spec.ts,**/*.test.ts,**/*.config.ts,**/*.module.ts,**/*.d.ts,**/*.model.ts,**/*.interface.ts,**/*.enum.ts,**/*.type.ts,**/*.js,projects/*-app/**,**/_mocks/**,**/__mocks__/**'
```
