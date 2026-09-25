# Changelog

The changelog is organized by release versions, with each release containing sections for different components of the project.
Each component's changes are categorized into Added, Changed, Fixed, and Removed.

## **Release 4.1.5** - 09-04-2025

### Darwin Logging

## [4.3.2] - 28-03-2025

### Bugfix

- Update `confluent-kafka` dependency to version 2.8.2

### Darwin Composer

## [4.3.1] - 28-03-2025

### Added

- Darwin Logging to v4.3.2

## **Release 4.1.3** - 13-02-2025

### Darwin Middlewares

#### [4.1.3] - 10-02-2025

##### Changed

- Update Pipfile dependencies to use '>=' constraints.

### Darwin Security

#### [4.2.3] - 10-02-2025

##### Changed

- Updated package dependencies `setuptools` and `requests`.
- Update Pipfile dependencies to use '>=' constraints.

### Darwin Logging

#### [4.3.0] - 10-02-2025

##### Added

- Thundera headers propagation for headers "sessionid" and "businessid"
- logging for Thundera fields "customlog.sessionReference" and "customlog.businessReference"
- DARWIN_LOGGING_KAFKA_TECHNICAL_TOPIC environment variable
- DARWIN_LOGGING_KAFKA_ACTIVITY_TOPIC environment variable
- tech_log and act_log loggers to send manual logs.
- DARWIN_LOGGING_MANUAL_ACTIVITY_LOG environment variable.
- DARWIN_LOGGING_MANUAL_TECHNICAL_LOG environment variable.
- DARWIN_LOGGING_RETRIES environment variable.
- DARWIN_LOGGING_RETRY_TIMEOUT environment variable.

##### Removed

- DARWIN_LOGGING_KAFKA_UNIQUE_TOPIC environment variable

##### Changed

- Updated package dependencies `setuptools` and `requests`.
- make_request migrated to use aiohttp. It is now asynchronous
- Python retry pattern using [tenacity](https://tenacity.readthedocs.io/en/latest/).
- Update Pipfile dependencies to use '>=' constraints

### Darwin Error Handler

#### [4.1.2] - 10-02-2025

##### Changed

- Updated package dependencies `setuptools`.
- Update Pipfile dependencies to use '>=' constraints

### Darwin Composer

## [4.3.0] - 11-02-2025

### Changed

- Update Pipfile dependencies to use '>=' constraints.

### Added

- Darwin Security to v4.2.3
- Darwin Middleware to v4.1.3
- Darwin Logging to v4.3.0
- Darwin Error Handling to v4.1.2

## **Release 4.1.2** - 20-11-2024

### Darwin Middlewares

#### [4.1.2] - 20-11-2024

##### Changed

- Updated package dependencies `setuptools`.

##### Fixed

- Issue with parameters when initiating i18n middleware.

### Darwin Security

#### [4.2.2] - 18-10-2024

##### Fixed

- We fix [CVE-2024-47874](https://cwe.mitre.org/data/definitions/770.html)

### Darwin Logging

#### [4.2.3] - 17-10-2024

##### Fixed

- We fix [CVE-2024-47874](https://cwe.mitre.org/data/definitions/770.html)

### Darwin Error Handler

#### [4.1.1] - 17-10-2024

##### Fixed

- We fix [CVE-2024-47874](https://cwe.mitre.org/data/definitions/770.html)

### Darwin Composer

## [4.2.5] - 20-11-2024

### Changed

- Updated package dependencies `setuptools` and `requests`.

### Added

- Darwin Security to v4.2.2
- Darwin Middleware to v4.1.2
- Darwin Logging to v4.2.3
- Darwin Error Handling to v4.1.1

## **Release 4.1.0** - 16-09-2024

### Darwin Error Handler

#### [4.1.0] - 04-08-2024

##### Added

- Included `tomli` dependency for TOML parsing and utilized by `pyproject.toml`.
- Support for Pydantic validation errors
- Support for 404 errors
- Technical logs during error handling

### Darwin Security

#### [4.2.0] - 10-09-2024

##### Added

- Introduced an environment variable to enable JWT audience verification.

##### BugFix

- Resolved an issue with audience handling in JWK tokens.
- Fix environment variable DARWIN_SECURITY_WHITE_LIST

### Darwin Logging

#### [4.2.2] - 16-09-2024

##### Fixed

- Fixed a bug where the kafka_host was not being evaluated correctly.

### Darwin Middlewares

#### [4.1.0] - 04-08-2024

##### Added

- Darwin I18n.

### Darwin Composer

#### [4.2.2] - 16-09-2024

##### Added

- Darwin Logging to v4.2.2

## Chart

### To 2.4.1

- We fix the environment variable value **DARWIN_MIDDLEWARES_I18N_LOCALES** in the deployment.yaml file.

### To 2.4.0

- We fix volumeMounts and volumes indentation.
- We update the .helmignore file.
- We update the the common library dependency to a new version and a new repository.
- We add the **service.overrideServiceName** property to allow to override the service name.
- We remove the **darwin.configType** property and add the **darwin.config.type** property to allow to configure the configmaps and secrets. Possible values are: **cm**, **secret**, **cm-secret** and **none**. We maintain the backward compatibility.
- We add the **darwin.config.overrideConfigMapName** property to allow to overwrite the name of the ConfigMap that contains the configuration.
- We add the **darwin.config.overrideSecretName** property to allow to overwrite the name of the Secret that contains the configuration.
- We add the **darwin.i18n** property to allow to configure the Internationalization feature for the application.
- We add the **darwin.i18n.enabled** property to enable or disable the Internationalization feature.
- We add the **darwin.i18n.path** property to allow to change the path of the i18n files.
- We add the **darwin.i18n.overwriteConfigMapName** property to allow to overwrite the name of the ConfigMap that contains the i18n files.
