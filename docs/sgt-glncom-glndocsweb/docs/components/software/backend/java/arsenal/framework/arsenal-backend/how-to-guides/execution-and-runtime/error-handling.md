
# How to use the error handling capability

## Step by step guide

### Add the steps involved

1. In your pom.xml, you need to declare the dependency on the error starter, so
   that it has the necessary transitive dependencies and autoconfiguration:

    ```yaml
    <dependency>
        <groupId>com.santander.ars</groupId>
        <artifactId>gln-back-arsenal-backend-gluon-error-starter</artifactId>
    </dependency>
    ```

2. In the application.yaml file, an adjustment must also be made,
   activating/deactivating some properties:

    ```yaml
    arsenal:
        logging:
            console-log: true
            dev-mode: true
            isGluon: false
    ```

3. Inside the src/main/resources/errors folder, you store your
   internationalization files in .properties format, and the adopted taxonomy
   convention is: errors_[LanguageCode]_[CountryCode].properties. But you can
   modify this via application.yaml. In this file, just like in Spring, we place
   the error messages with their proper identifiers.

4. Configuration of Application Errors

    ```properties
    # ==================== Application Errors ====================
    apparsenal.not_found.message=Arsenal app not found.
    ```

5. We can consume these .properties files directly in Java enums, so that they
   can be used in other layers of your application. We do this by declaring a
   common enum and implementing the com.santander.ars.error.catalog.ErrorCode
   interface.

    ```java
    public enum AppArsenalErrorCode implements ErrorCode {
        requestWithIdNotFound(404, "apparsenal.not_found");
    }
    ```

    !!! tip "Note"
        Note that the starter allows you to browse the .properties files through
        this key declared in the enum.

6. After that, you can create your custom exceptions to refine the use of this
   enum and, with that, your internationalized errors. We do this by extending
   the com.santander.ars.error.exceptions.AbstractApplicationException class:

    ``` java
    public class BusinessException extends AbstractApplicationException {

        private static final HttpCode DEFAULT_HTTP_CODE;

        public BusinessException(ErrorCode errorCode, String... messageArgs) {
            this(errorCode, (Throwable) null, messageArgs);
        }

    }
    ```

7. Finally, in any layer of your application, given the necessary exception
   handling, we can now throw our custom exceptions that will be able to use the
   resources configured so far, for example:

    ```java
    return mapper.toDomain(
        appArsenalData.orElseThrow(
            () -> new BusinessException(AppArsenalErrorCode.ERROR_APPARSENAL_NOT_FOUND)));
    ```

8. This will return an error in the following format in its payload (Gluon
   standard with error array):

    ```json
    {
    "errors": [
        {
        "code": "404",
        "message": "AppArsenal não foi encontrado(a).",
        "level": "ERROR",
        "description": "apparsenal.not_found"
        }
    ]
    }
    ```

You can also use visual dashboards to communicate related information, tips, or
warning recommendations to the user.
