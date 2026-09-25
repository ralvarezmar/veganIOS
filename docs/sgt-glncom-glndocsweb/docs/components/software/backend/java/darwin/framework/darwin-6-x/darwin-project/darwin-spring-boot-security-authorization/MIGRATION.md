# Darwin-spring-boot-security-authorization Migration guides

## Version 3.0.0-RELEASE

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Rename KEY\_PROVIDER\_ERROR constant to `PKM_SERVICE_ERROR` and update value.

- Rename *updateAuthenticationParameters()* from `OCProcessor` to ***updateAuthentication()***.

<!end:300>

## Version 2.6-RELEASE

<!tag:261>

### Rename and Location of the ErrorModel Class

In version 2.6.1, the location of the ErrorModel class is changed to the package `es.santander.darwin.common.exceptions.dto` of the module `darwin-spring-boot-common`. Due to the existence of a previous class with the same name (ErrorModel) in the
destination package, the name of the class that comes from the Authorization package is changed to ErrorModelGateway since this class models any error message that comes from a Gateway.

<!end:261>

<!tag:260>

### Changing the location of the enumerated scope

In version 2.6, the enumeration that contains the possible values of **Scope** has changed its location to the package `es.santander.darwin.common.authorization.types` of the module `darwin-spring-boot-common`

### Changing the location of the OperationType enumeration

In version 2.6, the enumeration that contains the possible values of **OperationType** has changed its location to the package `es.santander.darwin.common.authorization.types` of the module `darwin-spring-boot-common`

<!end:260>
