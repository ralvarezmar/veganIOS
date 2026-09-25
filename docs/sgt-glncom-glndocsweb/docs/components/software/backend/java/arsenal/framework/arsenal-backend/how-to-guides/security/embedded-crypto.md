# Embedded Cryptography

Embedded criptography is an implementation of DLB Cripto that allows encryption and decryption operations to be embedded directly into backend applications, without the need to make remote calls to the DLB Server.

This type of encryption is applicable for cases of communication with frontends. It is necessary for the frontend in question to perform a prior key exchange so that the encryption context (encryptedObject) is present in the Apigee/ZUP
section and can be sent to the microservice.

The most common scenario where encryption is applied is to protect sensitive data transmitted between services. Microservices need to be able to decrypt fields in requests, and also to encrypt fields in API responses.

To do this, the developer would need to make calls to the DLB Cripto encryption/decryption methods manually, for each field of the message.

To facilitate this process, we offer the **gln-back-arsenal-backend-lib-embeddedcrypto-starter**, capable of encrypting/decrypting message fields by simply placing a note on them.

## Step by step guide

1. Include starter dependency in pom.xml

    ``` { .xml .copy }
    <dependency>
        <groupId>com.santander.ars</groupId>
        <artifactId>gln-back-arsenal-backend-lib-embeddedcrypto-starter</artifactId>
    </dependency>
    ```

   The starter, by default, requires server security settings to check whether the encryption key is contained within the
   security token. To do this, we must also add the oauth2 resource server security lib to the application

    ``` { .xml .copy }
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
    </dependency>
    ```

2. For application security configurations, obtaining tokens, etc., please check the documentation
   [protecting microservices](./authentication-configuration.md).

3. Pay attention to the prerequisites of the encryption model: The embedded encryption model provides that requests sent to
   the backend application are accompanied by an object described by the Security Architecture as encryptedObject. The
   encryptedObject is a kind of cryptographic context that allows the backend to encrypt/decrypt information directly, without
   the need to communicate with the DLB Server.

    > The encryptedObject is automatically placed in the Apigee/ZUP session after the Key Exchange API call.

   The **gln-back-arsenal-backend-lib-embeddedcrypto-starter** stater provides for the EncryptedObject to be received by the application.

   Obtaining the EncryptedObject key can be done in 4 different ways.

   * The first check is if the token received by the application contains the claim ***cryptographicContext***.
   * If the above check does not return anything, it is checked whether the token received by the application contains the
     ***chaveCripto*** claim.
   * If the above check returns nothing, it is checked whether the token received by the application contains the
     ***legacy-session*** claim.
   * If the above check returns nothing, the extraction is checked using the http header ***X-EncryptedObject***. The name of this header
     can be customized. See the library configuration section below for more details on how to perform this configuration.

    > Encryption is only applicable to fields of type String and that are not marked with the final modifier!

4. Encrypting Information:
   As the projects are based on Contract-First, to encrypt the field, it is necessary to inform in the yaml file which fields
   will be encrypted, as per the example below:

    ``` { .yaml .copy }
    components:
        schemas:
            AppArsenalRequestDTO:
            type: object
            properties:
                otherInfo:
                type: string
                x-field-extra-annotation: |-
                    @com.fasterxml.jackson.databind.annotation.JsonSerialize (using = com.santander.ars.embeddedcrypto.security.ArsenalEmbeddedCryptoSerializer.class)
    ```

   In the example above, the x-field-extra-annotation tag tells openapi-generator that the annotations below should be included when generating the code. The x-field-extra-annotation tag must be added to all fields to be encrypted.

5. Decrypting Information:
   As the projects are based on Contract-First, to encrypt the field, it is necessary to inform in the yaml file which fields
   will be decrypted, as per the example below:

    ``` { .yaml .copy }
    components:
        schemas:
            AppArsenalRequestDTO:
            type: object
            properties:
                otherInfo:
                type: string
                x-field-extra-annotation: |-
                    @com.fasterxml.jackson.databind.annotation.JsonDeserialize (using = com.santander.ars.embeddedcrypto.security.ArsenalEmbeddedCryptoDeserializer.class)
    ```

   The x-field-extra-annotation tag must be added to all fields to be decrypted.

!!! tip

    If the same field must be encrypted and decrypted, use the x-field-extra-annotation tag as follows:

    ``` { .yaml .copy }
    x-field-extra-annotation: |-
    @com.fasterxml.jackson.databind.annotation.JsonDeserialize (using = com.santander.ars.embeddedcrypto.security.ArsenalEmbeddedCryptoDeserializer.class)
    @com.fasterxml.jackson.databind.annotation.JsonSerialize (using = com.santander.ars.embeddedcrypto.security.ArsenalEmbeddedCryptoSerializer.class)
    ```

## Configurations

When noting the fields that contain sensitive information, you will notice that the component will always try to
encrypt/decrypt these fields by default. We know that this behavior can make local development and testing difficult,
which is why the starter offers a configuration parameter (enabled) that allows you to disable it
without the application code needing to be modified/commented.

It is also possible to change the name of the HTTP header where the encryptedObject is transmitted through the
header-name parameter.

To disable the library only in a local environment, change the enabled property as shown in the example below:

``` { .yaml .copy }
arsenal:
  library:
    embeddedcrypto:
      enabled: false
```

To change the name of the default header, change the header-name property as shown in the example below:

``` { .yaml .copy }
arsenal:
  library:
    embeddedcrypto:
      header-name: X-CustomEncryptedObject
```

!!! tip

    For tests, you can use the following key as **X-EncryptedObject**:

    ``` { .text .copy }
    rO0ABXNyAB9jb20uYWx0ZWMuYnNici5hcHAuZGwuZWNjLkRMRUNDKcooZ7jn/poCAAB4cgAiY29tLmFsdGVjLmJzYnIuYXBwLmRsLmVjYy5ETENyeXB0b0hyPt8/TNWSAwAGWgAGY2xpZW50QgADeG9yTAADa2V5dAASTGphdmEvbGFuZy9TdHJpbmc7TAAHa2V5UGFpcnQAF0xqYXZhL3NlY3VyaXR5L0tleVBhaXI7TAAJcHVibGljS2V5cQB+AAJMAAZyYW5kb210ABxMamF2YS9zZWN1cml0eS9TZWN1cmVSYW5kb207eHB3LAAAACceLywpKy0vKSkoJy4tKCssKycmJyYqLicqKy8rKSgtKiwnJi0pLCwveA==
    ```

    To test de encryption, mark a field with **ArsenalEmbeddedCryptoSerializer** and send a request with the X-EncryptedObject
    header, the response should be encrypted.

    And to test decryption, you can use the following request body:

    ``` { .text .copy }
    {
        "otherInfo": "1\\GlLq2tuz5x4Su6GbwVPLXg==\\ex/rzxY90ByrHccQgOqpXkig4JjgnLMJGCWU/GbyVRs="
    }
    ```

    Then the response will be in plain text:

    ``` { .text .copy }
    {
        "otherInfo": "informacao-secreta"
    }
    ```

To retrieve the embedded cryptographic context, use the **getEmbeddedCryptoContext** static method. This method access the application`s cryptographic context and can be obtained via EmbeddedCryptoContextHolder class.

This ensures proper usage of cryptographic features within the application environment to encrypt and decrypt using the embedded key.

``` { .java .copy linenums="1" hl_lines="8"}
@Service
@RequiredArgsConstructor
public class AppArsenalServiceImpl implements AppArsenalService {

    public Page<AppArsenalResponseDTO> getPageable(Pageable pageable) {
        System.out.println(
            EmbeddedCryptoContextHolder.getEmbeddedCryptoContext()
        );
        ...
    }
}
```
