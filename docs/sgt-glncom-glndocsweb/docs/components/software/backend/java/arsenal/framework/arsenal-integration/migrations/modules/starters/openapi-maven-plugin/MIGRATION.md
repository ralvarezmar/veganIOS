# Migration Guide

    All notable versions to project `gln-back-arsenal-integration-openapi-maven-plugin` will be documented in this file.

## VERSION 4.7.4

<!tag:474>

We added default Actuator configurations

<!end:474>

## VERSION 4.4.0

<!tag:440>

In this version, the errorGluonFormat parameter was renamed to isGluon, the generated openapi file was changed with new observability fields and schema definitions were considered using the first occurrence of allOf

<!end:440>

## VERSION 4.3.0

<!tag:430>

We added the parameter errorGluonFormat that switch between the code that will handles the Exceptions and transleted the code comments to english

<!end:430>

## VERSION 4.2.0

<!tag:420>

- Added a Log Technical error when a Exception is thrown

<!end:420>

## VERSION 4.1.0

<!tag:410>

Some improvements were made, below:

- An observability launcher has been added
- Added @AutoConfigureObservability annotation to the test template

<!end:410>

## VERSION 4.0.0

<!tag:400>

- We adapted project to gluon standards and upgrade the version following the parent that receives the upgrade of the Apache Camel v4.0.0-M3
  
<!end:400>

## VERSION 3.7.6

<!tag:376>

In this version, we made fix, changes and improvements:

- Fixed the error handler to stop the flow when receiving an error
- Changed the generic error handling to return formatted data
- Added handling encrypted data in routes
- Added OAUTH token cryptographic context extraction
- Added generation of new OAUTH token with cryptographic context data using Client Credentials

<!end:376>
