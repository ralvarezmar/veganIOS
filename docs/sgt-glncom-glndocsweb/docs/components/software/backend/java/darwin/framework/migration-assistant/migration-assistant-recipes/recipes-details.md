# Darwin Recipes Detail

## Recipes to migrate the configuration to Darwin 2.11.x from Darwin 2.x {#recipe_migration_from_darwin}

The following recipes are responsible for migrating Darwin properties found in application.properties and application.yml that have changed or become deprecated when upgrading to Darwin Spring Boot version 2.11.x.

### Migrate Logging library properties

Migrates the Logging library properties found in application.properties and application.yml.

#### Properties Deprecated

| Darwin 2.x | Darwin {darwin-spring-boot-211-version} |
| --- | --- |
| darwin.logging.app-key | darwin.app-key |
| darwin.logging.log-level | logging.level |

### Migrate Omnichannel library properties

Migrates the Omnichannel library properties found in application.properties and application.yml.

#### Properties Deprecated

| Darwin 2.x | Darwin {darwin-spring-boot-211-version} |
| --- | --- |
| <p style="color:red">darwin.omnichannel.security.filter-order</p> | <p style="color:green">darwin.omnichannel.filter.order</p> |

### Migrate Authentication library properties

Migrates the Authentication library properties found in application.properties and application.yml.

#### Properties Deprecated

|Darwin 2.x | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">darwin.security.sts-retries</p> | *property deleted*|
|<p style="color:red">darwin.security.omnichannel</p> | *property deleted*|

### Migrate Extended Error library properties

Migrates the Extended Error library properties found in application.properties and application.yml.

#### Properties Deprecated

|Darwin 2.x | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">darwin.leancore.error-translate-url</p> | <p style="color:green">darwin.extended-error.error-translate-url</p>|
|<p style="color:red">darwin.leancore.error-translate-connector.connect-timeout</p> | <p style="color:green">darwin.extended-error.error-translate-connector.connect-timeout</p>|
|<p style="color:red">darwin.leancore.error-translate-connector.max-connections</p> | <p style="color:green">darwin.extended-error.error-translate-connector.max-connections</p>|
|<p style="color:red">darwin.leancore.error-translate-connector.pending-acquire-timeout</p> | <p style="color:green">darwin.extended-error.error-translate-connector.pending-acquire-timeout</p>|
|<p style="color:red">darwin.leancore.error-translate-connector.read-timeout</p> | <p style="color:green">darwin.extended-error.error-translate-connector.read-timeout</p>|
|<p style="color:red">darwin.leancore.error-translate-connector.write-timeout</p> | <p style="color:green">darwin.extended-error.error-translate-connector.write-timeout</p>|

### Migrate Partenon library properties

Migrates the Partenon library properties found in application.properties and application.yml.

#### Properties Deprecated

|Darwin 2.x | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">partenon.{*}</p> | <p style="color:green">darwin.partenon.default.{*}</p>|

### Migrate other properties

Migrates other properties found in application.properties and application.yml.

#### Properties Deprecated

|Darwin 2.x | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">spring.security.filter-order</p> | *property deleted*|
|<p style="color:red">spring.security.user.name</p> | *property deleted*|
|<p style="color:red">spring.security.user.password</p> | *property deleted*|
|<p style="color:red">management.security.enabled</p> | *property deleted*|

#### New properties

If they are not defined, the following properties will be added with their default value:

!!! warning

    Currently, there is a known limitation that does not allow adding new properties in property files, so the following mandatory properties will not be included (*this limitation **does not apply** to yaml configuration files*). In this case, manual changes will need to be made after the automation run.

|Nombre | Valor por defecto|
|--- | ---|
|<p style="color:green">darwin.logging.kafka.server</p> | ${env.logging-server}|
|<p style="color:green">spring.session.store-type</p> | none|
|<p style="color:green">spring.cache.type</p> | caffeine|
|<p style="color:green">spring.cache.caffeine.spec</p> | expireAfterWrite=10m|
|<p style="color:green">spring.lifecycle.timeout-per-shutdown-phase</p> | 2m|
|<p style="color:green">server.forward-headers-strategy</p> | framework|
|<p style="color:green">server.shutdown</p> | graceful|
|<p style="color:green">management.endpoint.health.show-details</p> | ALWAYS|
|<p style="color:green">health.config.enabled</p> | false|
|<p style="color:green">springdoc.swagger-ui.disable-swagger-default-url</p> | true|
|<p style="color:green">springdoc.swagger-ui.path</p> | /swagger-ui.html|

## Recipes to migrate the configuration to Darwin 2.11.x from NUAR

The following recipes are responsible for migrating NAUR properties found in application.properties and application.yml that have changed or become deprecated when upgrading to Darwin version 2.11.x.

### Migrate Core library properties

Migrates the Core library properties found in application.properties and application.yml.

#### Properties Deprecated

|Nuar | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">es.santander.nuar.name</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.async.await-termination-seconds</p> | <p style="color:green">darwin.core.async.await-termination-seconds</p>|
|<p style="color:red">es.santander.nuar.async.core-pool-size</p> | <p style="color:green">darwin.core.async.core-pool-size</p>|
|<p style="color:red">es.santander.nuar.async.enabled</p> | <p style="color:green">darwin.core.async.enabled</p>|
|<p style="color:red">es.santander.nuar.async.keep-alive-seconds</p> | <p style="color:green">darwin.core.async.keep-alive-seconds</p>|
|<p style="color:red">es.santander.nuar.async.max-pool-size</p> | <p style="color:green">darwin.core.async.max-pool-size</p>|
|<p style="color:red">es.santander.nuar.async.queue-capacity</p> | <p style="color:green">darwin.core.async.queue-capacity</p>|
|<p style="color:red">es.santander.nuar.async.thread-name-prefix</p> | <p style="color:green">darwin.core.async.thread-name-prefix</p>|
|<p style="color:red">es.santander.nuar.connect-timeout</p> | <p style="color:green">darwin.core.rest-template.connect-timeout</p>|
|<p style="color:red">es.santander.nuar.read-timeout</p> | <p style="color:green">darwin.core.rest-template.read-timeout</p>|
|<p style="color:red">es.santander.nuar.connection-request-timeout</p> | <p style="color:green">darwin.core.rest-template.connection-request-timeout</p>|

### Migrate Logging library properties

Migrates the Logging library properties found in application.properties and application.yml.

#### Properties Deprecated

|Nuar | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">es.santander.nuar.logging.active</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.activity</p> | <p style="color:green">darwin.logging.activity.enabled</p>|
|<p style="color:red">es.santander.nuar.logging.app-key</p> | <p style="color:green">darwin.app-key</p>|
|<p style="color:red">es.santander.nuar.logging.application</p> | <p style="color:green">darwin.logging.application</p>|
|<p style="color:red">es.santander.nuar.logging.artifact-version</p> | <p style="color:green">darwin.logging.paas-app-version</p>|
|<p style="color:red">es.santander.nuar.logging.environment</p> | <p style="color:green">darwin.logging.environment</p>|
|<p style="color:red">es.santander.nuar.logging.functional.active</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.functional.logged-endpoints</p> | <p style="color:green">darwin.logging.functional.logged-endpoints</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.properties</p> | <p style="color:green">darwin.logging.kafka.properties</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.server</p> | <p style="color:green">darwin.logging.kafka.server</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.topic</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.kafka.topic.activity</p> | <p style="color:green">darwin.logging.kafka.topic.activity</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.topic.frontend</p> | <p style="color:green">darwin.logging.kafka.topic.frontend</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.topic.functional</p> | <p style="color:green">darwin.logging.kafka.topic.functional</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.topic.security</p> | <p style="color:green">darwin.logging.kafka.topic.security</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.topic.technical</p> | <p style="color:green">darwin.logging.kafka.topic.technical</p>|
|<p style="color:red">es.santander.nuar.logging.kafka.unique-topic</p> | <p style="color:green">darwin.logging.kafka.unique-topic</p>|
|<p style="color:red">es.santander.nuar.logging.log-level.activity</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.log-level.frontend</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.log-level.functional</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.log-level.root</p> | <p style="color:green">logging.level.root</p>|
|<p style="color:red">es.santander.nuar.logging.log-level.security</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.log-level.technical</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.paas-app-version</p> | <p style="color:green">darwin.logging.paas-app-version</p>|
|<p style="color:red">es.santander.nuar.logging.paas-project</p> | <p style="color:green">darwin.logging.paas-project</p>|
|<p style="color:red">es.santander.nuar.logging.pattern.activity</p> | <p style="color:green">darwin.logging.pattern.activity</p>|
|<p style="color:red">es.santander.nuar.logging.pattern.console</p> | <p style="color:green">darwin.logging.pattern.console</p>|
|<p style="color:red">es.santander.nuar.logging.pattern.frontend</p> | <p style="color:green">darwin.logging.pattern.frontend</p>|
|<p style="color:red">es.santander.nuar.logging.pattern.functional</p> | <p style="color:green">darwin.logging.pattern.functional</p>|
|<p style="color:red">es.santander.nuar.logging.pattern.security</p> | <p style="color:green">darwin.logging.pattern.security</p>|
|<p style="color:red">es.santander.nuar.logging.pattern.technical</p> | <p style="color:green">darwin.logging.pattern.technical</p>|
|<p style="color:red">es.santander.nuar.logging.root.log-level</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.subapplication</p> | <p style="color:green">darwin.logging.subapplication</p>|
|<p style="color:red">es.santander.nuar.logging.subapplication-version</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.subsystem</p> | <p style="color:green">darwin.logging.subsystem</p>|
|<p style="color:red">es.santander.nuar.logging.system</p> | <p style="color:green">darwin.logging.system</p>|
|<p style="color:red">es.santander.nuar.logging.technical.package</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.technical.packages-log-level</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.technical.log-level</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.time-stamp-format</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.logging.time-stamp-pattern</p> | *property deleted*|

### Migrate Omnichannel library properties

Migrates the Omnichannel library properties found in application.properties and application.yml.

#### Properties Deprecated

|Nuar | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">es.santander.nuar.util.omnichannel.external-channel-map</p> | <p style="color:green">darwin.omnichannel.external-channel-map</p>|
|<p style="color:red">es.santander.nuar.util.omnichannel.header</p> | <p style="color:green">darwin.omnichannel.header.channel</p>|
|<p style="color:red">es.santander.nuar.util.omnichannel.parameter</p> | <p style="color:green">darwin.omnichannel.parameter.channel</p>|
|<p style="color:red">es.santander.nuar.util.omnichannel.security.filter-order</p> | <p style="color:green">darwin.omnichannel.filter.order</p>|

### Migrate Authentication library properties

Migrates the Authentication library properties found in application.properties and application.yml.

#### Properties Deprecated

|Nuar | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">es.santander.nuar.util.security.audience</p> | <p style="color:green">darwin.security.audience</p>|
|<p style="color:red">es.santander.nuar.util.security.auth-query-parameter</p> | <p style="color:green">darwin.security.auth-query-parameter</p>|
|<p style="color:red">es.santander.nuar.util.security.enabled</p> | <p style="color:green">darwin.security.enabled</p>|
|<p style="color:red">es.santander.nuar.util.security.issuer</p> | <p style="color:green">darwin.security.issuer</p>|
|<p style="color:red">es.santander.nuar.util.security.omnichannel</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.util.security.pkm-endpoint</p> | <p style="color:green">darwin.security.pkm-endpoint</p>|
|<p style="color:red">es.santander.nuar.util.security.remote-key-server-url</p> | <p style="color:green">darwin.security.pkm-endpoint</p>|
|<p style="color:red">es.santander.nuar.util.security.sts-endpoint</p> | <p style="color:green">darwin.security.sts-endpoint</p>|
|<p style="color:red">es.santander.nuar.util.security.remote-sts-uri</p> | <p style="color:green">darwin.security.sts-endpoint</p>|
|<p style="color:red">es.santander.nuar.util.security.sts-retries</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.util.security.white-list</p> | <p style="color:green">darwin.security.white-list</p>|
|<p style="color:red">es.santander.nuar.util.restTemplate.connection-request-timeout</p> | <p style="color:green">darwin.security.rest-template.connection-request-timeout</p>|
|<p style="color:red">es.santander.nuar.util.restTemplate.connection-timeout</p> | <p style="color:green">darwin.security.rest-template.connection-timeout</p>|
|<p style="color:red">es.santander.nuar.util.restTemplate.read-timeout</p> | <p style="color:green">darwin.security.rest-template.read-timeout</p>|

### Migrate Authorization library properties

Migrates the Authorization library properties found in application.properties and application.yml.

#### Properties Deprecated

|Nuar | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">es.santander.nuar.util.security.authorization.remote.coc</p> | <p style="color:green">darwin.security.authorization.remote.coc</p>|
|<p style="color:red">es.santander.nuar.util.security.authorization.remote.con</p> | <p style="color:green">darwin.security.authorization.remote.con</p>|
|<p style="color:red">es.santander.nuar.util.security.authorization.authorized-whitelist</p> | <p style="color:green">darwin.security.authorization.authorized-whitelist</p>|
|<p style="color:red">es.santander.nuar.util.security.authorization.key-provider</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.util.security.authorization.remote.oprative-business-retries</p> | *property deleted*|
|<p style="color:red">es.santander.nuar.util.security.authorization.remote.oprative-channel-retries</p> | *property deleted*|

### Migrate WebService library properties

Migrates the WebService library properties found in application.properties and application.yml.

#### Properties Deprecated

|Nuar | Darwin {darwin-spring-boot-211-version}|
|--- | ---|
|<p style="color:red">es.santander.nuar.util.remote.ws.security.types</p> | <p style="color:green">darwin.webservices.security-types</p>|
|<p style="color:red">es.santander.nuar.util.remote.ws.security.types.mode</p> | <p style="color:green">darwin.webservices.security-types.mode</p>|
|<p style="color:red">es.santander.nuar.util.remote.ws.security.types.name</p> | <p style="color:green">darwin.webservices.security-types.name</p>|
|<p style="color:red">es.santander.nuar.util.remote.ws.security.types.password</p> | <p style="color:green">darwin.webservices.security-types.password</p>|
|<p style="color:red">es.santander.nuar.util.remote.ws.security.types.user</p> | <p style="color:green">darwin.webservices.security-types.user</p>|
