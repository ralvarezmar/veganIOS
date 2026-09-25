# MIGRATION GUIDES {!include-markdown '../snippets/versions.md' start='<!tag:back-version-schema>' end='<!end:back-version-schema>'!}

All notable migrations guide to this project will be documented in this file.

## MIGRATION GUIDE TO 3.14.0 AND ABOVE

Archunit plugin configuration should be updated to use new version.

Substitute this configuration of archunit plugin at **build/plugins** in *pom.xml* from:

``` {.xml .copy}
<plugin>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-backend-archunit-plugin</artifactId>
    <executions>
        <execution>
            <phase>test</phase>
            <goals>
                <goal>arch-test</goal>
            </goals>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.santander.ars</groupId>
            <artifactId>gln-back-arsenal-backend-archunit-core</artifactId>
            <version>${revision}</version>
        </dependency>
    </dependencies>
</plugin>
```

to this configuration:

``` {.xml .copy}
<plugin>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-backend-archunit-plugin-v2</artifactId>
    <version>${arsenal-archunit.version}</version>
    <executions>
        <execution>
            <phase>test</phase>
            <goals>
                <goal>arch-test</goal>
            </goals>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.santander.ars</groupId>
            <artifactId>gln-back-arsenal-backend-archunit-core-v2</artifactId>
            <version>${arsenal-archunit.version}</version>
        </dependency>
    </dependencies>
</plugin>
```

And **arsenal-archunit.version** should be declared in **properties** as follows:

``` {.xml .copy}
<arsenal-archunit.version>1.0.0</arsenal-archunit.version>
```

## MIGRATION GUIDE FROM 3.9.4 TO 3.9.5

### `telemetry-log-starter` module

{! include-markdown './migrations/modules/starters/telemetry-log-starter/MIGRATION.md' start='<!tag:395>' end='<!end:395>' !}

## MIGRATION GUIDE FROM 3.9.3 TO 3.9.4

- Updated libraries with vulnerabilities found

### `telemetry-log-starter` module

{! include-markdown './migrations/modules/starters/telemetry-log-starter/MIGRATION.md' start='<!tag:394>' end='<!end:394>' !}

### `logback-plugin` module

{! include-markdown './migrations/modules/starters/logback-plugin/MIGRATION.md' start='<!tag:394>' end='<!end:394>' !}

### `lib-parent` module

{! include-markdown './migrations/modules/lib-parent/MIGRATION.md' start='<!tag:394>' end='<!end:394>' !}

### `base` module

{! include-markdown './migrations/archetypes/base/MIGRATION.md' start='<!tag:394>' end='<!end:394>' !}

## MIGRATION GUIDE FROM 3.9.0 TO 3.9.3

- We updated our framework to SpringBoot 3.2

### `archetype` module

{! include-markdown './migrations/archetypes/archetype/MIGRATION.md' start='<!tag:393>' end='<!end:393>' !}

### `base` module

{! include-markdown './migrations/archetypes/base/MIGRATION.md' start='<!tag:393>' end='<!end:393>' !}

### `mongodb` module

{! include-markdown './migrations/archetypes/mongodb/MIGRATION.md' start='<!tag:393>' end='<!end:393>' !}

## MIGRATION GUIDE FROM 3.8.0 TO 3.9.0

- In this version, we updated our framework to SpringBoot 3.2

## MIGRATION GUIDE FROM 3.7.2 TO 3.8.0

### `archetype` module

{! include-markdown './migrations/archetypes/archetype/MIGRATION.md' start='<!tag:380>' end='<!end:380>' !}

### `base` module

{! include-markdown './migrations/archetypes/base/MIGRATION.md' start='<!tag:380>' end='<!end:380>' !}

### `message-driven` module

{! include-markdown './migrations/archetypes/message-driven/MIGRATION.md' start='<!tag:380>' end='<!end:380>' !}

### `grpc` module

{! include-markdown './migrations/archetypes/grpc/MIGRATION.md' start='<!tag:380>' end='<!end:380>' !}

### `mongodb` module

{! include-markdown './migrations/archetypes/mongodb/MIGRATION.md' start='<!tag:380>' end='<!end:380>' !}

## MIGRATION GUIDE FROM 3.7.1 TO 3.7.2

### `embeddedmainframe` module

{! include-markdown './migrations/modules/starters/embeddedmainframe/MIGRATION.md' start='<!tag:372>' end='<!end:372>' !}

## MIGRATION GUIDE FROM 3.7.0 TO 3.7.1

### `archetype` module

{! include-markdown './migrations/archetypes/archetype/MIGRATION.md' start='<!tag:371>' end='<!end:371>' !}

### `base` module

{! include-markdown './migrations/archetypes/base/MIGRATION.md' start='<!tag:371>' end='<!end:371>' !}

### `message-driven` module

{! include-markdown './migrations/archetypes/message-driven/MIGRATION.md' start='<!tag:371>' end='<!end:371>' !}

### `grpc` module

{! include-markdown './migrations/archetypes/grpc/MIGRATION.md' start='<!tag:371>' end='<!end:371>' !}

### `mongodb` module

{! include-markdown './migrations/archetypes/mongodb/MIGRATION.md' start='<!tag:371>' end='<!end:371>' !}

## MIGRATION GUIDE FROM 3.6.2 TO 3.7.0

### `starter` module

{! include-markdown './migrations/archetypes/starter/MIGRATION.md' start='<!tag:370>' end='<!end:370>' !}

## MIGRATION GUIDE FROM 3.6.1 TO 3.6.2

### `archetype` module

{! include-markdown './migrations/archetypes/archetype/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

### `base` module

{! include-markdown './migrations/archetypes/base/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

### `message-driven` module

{! include-markdown './migrations/archetypes/message-driven/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

### `grpc` module

{! include-markdown './migrations/archetypes/grpc/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

### `mongodb` module

{! include-markdown './migrations/archetypes/mongodb/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

### `distributed-caching` module

{! include-markdown './migrations/modules/starters/distributed-caching/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

### `embeddedmainframe` module

{! include-markdown './migrations/modules/starters/embeddedmainframe/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

### `archunit-plugin` module

{! include-markdown './migrations/modules/arsenal-libs/arsenal-archunit-plugin/MIGRATION.md' start='<!tag:362>' end='<!end:362>' !}

## MIGRATION GUIDE FROM 3.4.1 TO 3.6.1

### `grpc` module

{! include-markdown './migrations/archetypes/grpc/MIGRATION.md' start='<!tag:361>' end='<!end:361>' !}

## MIGRATION GUIDE FROM 3.4.2 TO 3.4

### `mongodb` module

{! include-markdown './migrations/archetypes/mongodb/MIGRATION.md' start='<!tag:343>' end='<!end:343>' !}

## MIGRATION GUIDE FROM 3.4.1 TO 3.4.2

### `mongodb` module

{! include-markdown './migrations/archetypes/mongodb/MIGRATION.md' start='<!tag:342>' end='<!end:342>' !}

## MIGRATION GUIDE FROM 3.4.0 TO 3.4.1

### `base` module

{! include-markdown './migrations/archetypes/base/MIGRATION.md' start='<!tag:341>' end='<!end:341>' !}

### `message-driven` module

{! include-markdown './migrations/archetypes/message-driven/MIGRATION.md' start='<!tag:341>' end='<!end:341>' !}

## MIGRATION GUIDE FROM 3.1.X TO 3.4.0

### `base` module

{! include-markdown './migrations/archetypes/base/MIGRATION.md' start='<!tag:340>' end='<!end:340>' !}

### `message-driven` module

{! include-markdown './migrations/archetypes/message-driven/MIGRATION.md' start='<!tag:340>' end='<!end:340>' !}

## MIGRATION GUIDE FROM 3.X TO 3.1.X

### `gluon-error-starter` module

{! include-markdown './migrations/modules/starters/gluon-error-starter/MIGRATION.md' start='<!tag:310>' end='<!end:310>' !}

## VERSION 3.0.0

### `gluon-error-starter` module

{! include-markdown './migrations/modules/starters/gluon-error-starter/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}
