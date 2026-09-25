# Santander Spring Boot EmbeddedCrypto ![Version](https://img.shields.io/badge/version-1.0.0-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The Santander Spring Boot DLB Crypto library provides encryption and decryption capabilities for secure data handling in applications. It integrates seamlessly with Spring Boot and supports JSON serialization and deserialization for encrypted fields.

---

## Features

`Santander Spring Boot EmbeddedCrypto` auto-configuration detects the type of application it is running in and applies encryption and decryption functionalities accordingly.

!!! warning

    This library doesn't provide support for Reactive applications.

The library provides the following features:

### Encryption and Decryption

#### Deserialization

Decryption: Automatically decrypts fields in incoming requests using the `DlbCryptoDeserializer`.

#### Serialization

Encryption: Automatically encrypts fields in outgoing responses using the `DlbCryptoSerializer`.

---

## Installation and configuration

To add the library to any project, include the Maven dependency of its starter in the `pom.xml` file:

```xml
<dependency>
   <groupId>com.santander.framework.springboot</groupId>
   <artifactId>santander-spring-boot-starter-dlb</artifactId>
</dependency>
```

If it is necessary to read the encrypted data from the JWT token,
it is necessary to have the authentication activated,
so the following dependency should be added in the `pom.xml` file:

```xml
<dependency>
   <groupId>com.santander.framework.springboot</groupId>
   <artifactId>santander-spring-boot-starter-authentication</artifactId>
</dependency>
```

### Configuration

<!tag:properties>

| Name                                  | Default value             | Required | Description                                                                                | Supported values |
|---------------------------------------|---------------------------|----------|--------------------------------------------------------------------------------------------|------------------|
| santander.embeddedcrypto.enabled      | true                      | No       | Allows you to enable the Dlb Crypto feature. By default, it is enabled.                    | Boolean          |
| santander.embeddedcrypto.header-name  | X-EncryptedObject         | No       | Name of the Dlb crypto header to reador or to propagate                                    | String           |
| santander.embeddedcrypto.filter-order | Ordered.LOWEST_PRECEDENCE | No       | Order where the `UpdateDlbCryptoInfoFromRequestFilter` filter will be placed in the chain. | Number           |

<!end:properties>

## Exposed API

| Name                                                                                        | Type                                                     | Description                                                                | Application Type          |
|---------------------------------------------------------------------------------------------|----------------------------------------------------------|----------------------------------------------------------------------------|---------------------------|
| [JwtEncryptObjectExtractor](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/security/dlb/JwtEncryptObjectExtractor.html) | Class                                                    | Extracts the encrypted object from a JWT token using different strategies. | <ul><li>Servlet</li></ul> |
| [ClaimWrapper](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/security/dlb/ClaimWrapper.html)                           | Class                                                    | Wrapper class for encrypted claims extracted from JWT tokens.              | <ul><li>Servlet</li></ul> |
| [DlbCryptoSerializer](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/security/dlb/DlbCryptoSerializer.html)             | [ObjectMapper](https://www.javadoc.io/doc/com.fasterxml.jackson.core/jackson-databind/2.19.2/com/fasterxml/jackson/databind/JsonSerializer.html)   | Class responsible for serializing encrypted fields.                        | <ul><li>Servlet</li></ul> |
| [DlbCryptoDeserializer](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/security/dlb/DlbCryptoDeserializer.html)         | [ObjectMapper](https://www.javadoc.io/doc/com.fasterxml.jackson.core/jackson-databind/2.19.2/com/fasterxml/jackson/databind/JsonDeserializer.html) | Class responsible for deserializing encrypted fields.                      | <ul><li>Servlet</li></ul> |

## Library use cases

### Configure your Application

Ensure your application is configured to use the encryption and decryption capabilities.
Add the necessary dependencies to your `pom.xml`.

If you need to read encrypted data from the JWT token, ensure that the authentication starter is included in your project.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-dlb</artifactId>
</dependency>
<dependency>
   <groupId>com.santander.framework.springboot</groupId>
   <artifactId>santander-spring-boot-starter-authentication</artifactId>
</dependency>
```

### Decryption

#### Using an HTTP Client

1. Configure a **POST** request for the resource: [API Endpoint](http://localhost:8080/api/v1/santander)
2. Configure the headers, including the X-EncryptedObject key that will house the cryptographic context.

3. Adjust your openapi.yaml file to decrypt information in the request object.
    To enable decryption for a specific field in your request object, update your `openapi.yaml` file as follows:

    ```yaml
    components:
      schemas:
        TestRequestDTO:
          type: object
          properties:
            otherInfo:
              type: string
              x-field-extra-annotation: |-
                @com.fasterxml.jackson.databind.annotation.JsonDeserialize(using = com.santander.framework.springboot.security.dlb.DlbCryptoDeserializer.class)
      ```

    !!! note

        To view the decryption result, it is important that there are no settings in the openapi.yaml contract to encrypt in the response object.
        That is, there must be no x-field-extra-annotation in the response object.

4. Configure the Body, passing the JSON with the body of the encrypted request:

``` {"otherInfo": "1\\GlLq2tuz5x4Su6GbwVPLXg==\\ex/rzxY90ByrHccQgOqpXkig4JjgnLMJGCWU/GbyVRs=" } ```

### Encryption

Adjust your openapi.yaml file to decrypt information in the request object.
To enable decryption for a specific field in your request object, update your `openapi.yaml` file as follows:

```yaml
components:
  schemas:
    TestResponseDTO:
      type: object
      properties:
        id:
          type: integer
          format: int64
        otherInfo:
          type: string
          x-field-extra-annotation: |-
            @com.fasterxml.jackson.databind.annotation.JsonSerialize(using = com.santander.framework.springboot.security.dlb.DlbCryptoSerializer.class)
```

Configure the Body, passing the JSON with the decrypted request body:

```json
{
  "otherInfo": "informacao-secreta"
}
```

## Native compilation support

This module is not compatible with the native compilation.
