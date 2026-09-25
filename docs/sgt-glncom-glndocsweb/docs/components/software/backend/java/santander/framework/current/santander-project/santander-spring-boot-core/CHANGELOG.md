# Change Log

## Version 1.2.1

<!tag:121>

### 🐞 Bug Fixes

- Fix issue that prevents the obfuscation feature from working when the dependency `com.jayway.jsonpath:json-path` is excluded.
- Fix issue in the `SimpleObfuscationServiceImpl` that does not take into account lists as a type of field in a JSON structure.

### 📔 Documentation

- Improving explanation about *Obfuscation feature*

<!end:121>

## Version 1.0.1

<!tag:101>

### 🐞 Bug Fixes

- Fixed issue preventing `santander.core.http-clients.netty-http-client` properties from being applied when `santander.core.http-clients.apache-http-client`
  is unset.

<!end:101>

## Version 1.0.0

<!tag:100>

### ⭐ New Features

- Initial version. Based on Darwin Spring Boot version 6.2.1.
- Added to `Info` object the field `encryptedObject`.

<!end:100>
