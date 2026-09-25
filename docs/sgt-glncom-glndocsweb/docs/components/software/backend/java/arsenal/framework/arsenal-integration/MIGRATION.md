# ARSENAL MIGRATION GUIDES

All notable changes to this project will be documented in this file.

## MIGRATION GUIDE FROM ARSENAL 4.11.1 TO ARSENAL 4.12.0

- Starting with version 4.2.x, Apache Camel will no longer resolve rest paths with
  invalid [Java Pattern named groups (regex)](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html#groupname),
  such as "/users/{user_id}".

## MIGRATION GUIDE FROM ARSENAL 4.7.4 TO ARSENAL 4.9.0

### `rest-archetype` module

{! include-markdown './migrations/archetypes/rest-archetype/MIGRATION.md' start='<!tag:490>' end='<!end:490>' !}

### `core-starter` module

{! include-markdown './migrations/modules/starters/core-starter/MIGRATION.md' start='<!tag:490>' end='<!end:490>' !}

### `altair-connector` module

{! include-markdown './migrations/modules/starters/altair-connector/MIGRATION.md' start='<!tag:490>' end='<!end:490>' !}

### `security-channel-holder-starter` module

{! include-markdown './migrations/modules/starters/security-channel-holder-starter/MIGRATION.md' start='<!tag:490>' end='<!end:490>' !}

## MIGRATION GUIDE FROM ARSENAL 4.7.3 TO ARSENAL 4.7.4

### `rest-archetype` module

{! include-markdown './migrations/archetypes/rest-archetype/MIGRATION.md' start='<!tag:474>' end='<!end:474>' !}

### `openapi-maven-plugin` module

{! include-markdown './migrations/modules/starters/openapi-maven-plugin/MIGRATION.md' start='<!tag:474>' end='<!end:474>' !}

## MIGRATION GUIDE FROM ARSENAL 4.7.0 TO ARSENAL 4.7.3

### `rest-archetype` module

{! include-markdown './migrations/archetypes/rest-archetype/MIGRATION.md' start='<!tag:473>' end='<!end:473>' !}

## MIGRATION GUIDE FROM ARSENAL 4.4.0 TO ARSENAL 4.7.0

### `rest-archetype` module

{! include-markdown './migrations/archetypes/rest-archetype/MIGRATION.md' start='<!tag:470>' end='<!end:470>' !}

## MIGRATION GUIDE FROM ARSENAL 4.3.0 TO ARSENAL 4.4.0

### `rest-archetype` module

{! include-markdown './migrations/archetypes/rest-archetype/MIGRATION.md' start='<!tag:440>' end='<!end:440>' !}

### `openapi-maven-plugin` module

{! include-markdown './migrations/modules/starters/openapi-maven-plugin/MIGRATION.md' start='<!tag:440>' end='<!end:440>' !}

## MIGRATION GUIDE FROM ARSENAL 4.2.0 TO ARSENAL 4.3.0

### `rest-archetype` module

{! include-markdown './migrations/archetypes/rest-archetype/MIGRATION.md' start='<!tag:430>' end='<!end:430>' !}

### `observability-starter` module

{! include-markdown './migrations/modules/starters/observability-starter/MIGRATION.md' start='<!tag:430>' end='<!end:430>' !}

### `openapi-maven-plugin` module

{! include-markdown './migrations/modules/starters/openapi-maven-plugin/MIGRATION.md' start='<!tag:430>' end='<!end:430>' !}

## MIGRATION GUIDE FROM ARSENAL 4.1.1 TO ARSENAL 4.2.0

### `observability-starter` module

{! include-markdown './migrations/modules/starters/observability-starter/MIGRATION.md' start='<!tag:420>' end='<!end:420>' !}

### `openapi-maven-plugin` module

{! include-markdown './migrations/modules/starters/openapi-maven-plugin/MIGRATION.md' start='<!tag:420>' end='<!end:420>' !}

## MIGRATION GUIDE FROM ARSENAL 4.1.0 TO ARSENAL 4.1.1

### `observability-starter` module

{! include-markdown './migrations/modules/starters/observability-starter/MIGRATION.md' start='<!tag:411>' end='<!end:411>' !}

## MIGRATION GUIDE FROM ARSENAL 4.0.4 TO ARSENAL 4.1.0

### `observability-starter` module

{! include-markdown './migrations/modules/starters/observability-starter/MIGRATION.md' start='<!tag:410>' end='<!end:410>' !}

### `openapi-maven-plugin` module

{! include-markdown './migrations/modules/starters/openapi-maven-plugin/MIGRATION.md' start='<!tag:410>' end='<!end:410>' !}

## MIGRATION GUIDE FROM ARSENAL 4.0.0 TO ARSENAL 4.0.4

### `legacy-connector` module

{! include-markdown './migrations/modules/starters/legacy-connector/MIGRATION.md' start='<!tag:404>' end='<!end:404>' !}

## MIGRATION GUIDE FROM ARSENAL 3.7.6 TO ARSENAL 4.0.0

### `rest-archetype` module

{! include-markdown './migrations/archetypes/rest-archetype/MIGRATION.md' start='<!tag:400>' end='<!end:400>' !}

### `error-starter` module

{! include-markdown './migrations/modules/starters/error-starter/MIGRATION.md' start='<!tag:400>' end='<!end:400>' !}

### `observability-starter` module

{! include-markdown './migrations/modules/starters/observability-starter/MIGRATION.md' start='<!tag:400>' end='<!end:400>' !}

### `openapi-maven-plugin` module

{! include-markdown './migrations/modules/starters/openapi-maven-plugin/MIGRATION.md' start='<!tag:400>' end='<!end:400>' !}

## VERSION 3.7.6

### `openapi-maven-plugin` module

{! include-markdown './migrations/modules/starters/openapi-maven-plugin/MIGRATION.md' start='<!tag:376>' end='<!end:376>' !}
