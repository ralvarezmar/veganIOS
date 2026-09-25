# Photon Quarkus Embedded Crypto

The most common scenario where encryption is applied is to protect sensitive data that travels between services. Microservices need to be able to decrypt
fields from requests, and also to encrypt fields from API responses.

For this, the developer would need to make the calls to the Crypto DLB encrypt/decrypt methods manually, for each message field.

To facilitate this process, we offer the photon-quarkus-embedded-crypto library, capable of encrypting/decrypting message fields by simply placing
a note on them.

## Installation

To use the photon-quarkus-embedded-crypto library, the dependency below must be added to the application's pom.xml file

```xml
<dependency>
 <groupId>com.santander.photon</groupId>
 <artifactId>photon-quarkus-embedded-crypto</artifactId>
 <version>LATEST</version>
</dependency>
```

!!! tip "Attention!"

        After adding the dependency, the library is automatically activated.

## Prerequisites

The embedded encryption model predicts that requests sent to the backend application are accompanied by an object described by the Security
Architecture as encryptedObject. The encryptedObject is a kind of cryptographic context that allows the backend to encrypt/decrypt information directly,
without needing to communicate with the DLB Server.

!!! tip "Attention!"

    The encryptedObject is automatically placed in the Apigee/ZUP session after the Key Exchange API call.

The photon-quarkus-embedded-crypto library expects the encryptedObject to be received by the application in an HTTP header.

By default, the library expects to receive the encryptedObject in the X-EncryptedObject header, however the name of this header can be customized. See
the section on library configuration below for more details on how to do this configuration.

!!! tip "Attention!"

    Encryption is only applicable to fields of type String and that are not marked with the final modifier!

## How to use

#### Encrypting Information

As the projects are based on Contract-First, to encrypt the field, it is necessary to inform the yaml file which fields will be encrypted, as shown in the
example below:

```yaml
components:
  schemas:
      photon:
          type: object
          properties:
            id:
              type: integer
              format: int32
            name:
              type: string
              description: Name
              x-field-extra-annotation: |-
                @com.fasterxml.jackson.databind.annotation.JsonSerialize (using = com.santander.embedded.crypto.
                security.ArsenalPhotonContextualJsonSerializer.class)
            description:
              type: string
              description: Description
```

In the example above, the tag x-field-extra-annotation tells openapi-generator that the annotations below should be included at the time of code
generation. The x-field-extra-annotation tag must be added to all fields to be encrypted.

#### Tag Encryption

```yaml
x-field-extra-annotation: |-
 @com.fasterxml.jackson.databind.annotation.JsonSerialize (using = com.santander.photon.embedded.crypto.security.
  ArsenalPhotonContextualJsonSerializer.class)
```

#### Decrypting Information

To decrypt the field, it is necessary to inform the yaml file which fields will be decrypted, as shown in the example below:

```yaml
components:
 schemas:
     photon:
         type: object
         properties:
          id:
            type: integer
            format: int32
         name:
            type: string
            description: Name
            x-field-extra-annotation: |-
              @com.fasterxml.jackson.databind.annotation.JsonDeserialize (using = com.santander.embedded.crypto.
              security.ArsenalPhotonContextualJsonDeserializer.class)
         description:
          type: string
          description: Description
```

The x-field-extra-annotation tag must be added to all fields to be decrypted

#### Decryption tag

```yaml
x-field-extra-annotation: |-
 @com.fasterxml.jackson.databind.annotation.JsonDeserialize (using = com.santander.photon.embedded.crypto.security.
  ArsenalPhotonContextualJsonDeserializer.class)
```

If the same field must be encrypted and decrypted, inform the x-field-extra-annotation tag as follows:

```yaml
x-field-extra-annotation: |-
 @com.fasterxml.jackson.databind.annotation.JsonSerialize (using = com.santander.photon.embedded.crypto.security.
  ArsenalPhotonContextualJsonSerializer.class)
 @com.fasterxml.jackson.databind.annotation.JsonDeserialize (using = com.santander.photon.embedded.crypto.security.
  ArsenalPhotonContextualJsonDeserializer.class)
```

## Settings

When annotating fields that have sensitive information, you will notice that the library will always try to encrypt/decrypt these fields by default. We know
that this behavior can make development and local tests difficult, so the library offers a configuration parameter (enabled) that allows you to disable it
without the application code having to be modified/commented.

It is also possible to change the name of the HTTP header where the encryptedObject is trafficked through the header-name parameter

To disable the library only in the local environment, change the enabled property as shown below:

```yaml
quarkus.embedded-crypto.enabled=false
```

To change the default header name, change the header-name property as shown below:

```yaml
quarkus.embedded-crypto.header-name=X-EncryptedObject
```

!!! tip "Attention!"

    The above properties are already defined by default by the library and there is no need to inform them for the encryption to work.

If problems occur when decrypting the data, it is necessary to disable the client configuration, as shown in the example below. This setting is used by DLB.

```yaml
quarkus.embedded-crypto.client=false
```
