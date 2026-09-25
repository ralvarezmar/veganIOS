# Change Log

## Version 1.2.1

<!tag:121>

### 🐞 Bug Fixes

- The issue where the @ObfuscateFunctionalLog annotation did not work correctly when the REST mapping controller was defined in the interface instead of in the implementation class has been resolved.
- The issue where Functional helpers were always configured with an `ObfuscationServiceImpl` instance, even when the JsonPath dependency was excluded, has been resolved.

<!end:121>

## Version 1.1.0

<!tag:110>

### 🐞 Bug Fixes

- Fixed issue that prevented `excludeLoggingPaths` from being overwritten if any bean of type `Set.class` was defined in the application.

<!end:110>

## Version 1.0.0

<!tag:100>

### ⭐ New Features

- Initial version. Based on Darwin Spring Boot version 6.2.1.
- Apache Camel activity logging capacity.

<!end:100>
