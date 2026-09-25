# Arsenal

![home](./assets/images/home1.png)

Welcome to the Arsenal Integration Documentation!

## Arsenal Integration {!include-markdown '../snippets/versions.md' start='<!tag:int-version-schema>' end='<!end:int-version-schema>'!}

{!include-markdown '../snippets/versions.md' start='<!tag:int-current>' end='<!end:int-current>'!}

Arsenal Integration is used to develop stateless orchestrated Experience APIs
and Java BAAS APIs. Both Arsenal Backend and Arsenal Integration use Spring
Boot, but they are different frameworks: Arsenal Backend uses Spring Framework
as core and Arsenal Integration uses Apache Camel and they are not compatible
today. Check this [link](../arsenal-backend/index.md) to learn more about Arsenal
Backend.

## Blueprint of architecture

Below are illustrated the architecture layers and main capabilities provided by
Arsenal Cloud Native.

![blueprint](./assets/images/blueprint-arsenal.svg)
