# Photon Quarkus Error Handler

Photon Error Handler is an extension created to map exceptions to HTTP responses in a Jakarta RESTful Web Services
(JAX-RS) application. The extension handles Business Exception, Constraint Validation Exception and others exceptions
gracefully and return structured error responses aligned with Gluon format allowing for cleaner error handling and
consistent error responses across the API to the client. The Gluon format has the following structure:

``` { .json }
{
    "errors": [
        {
            "code": "String",
            "message": "String",
            "level": "String",
            "description": "String"
        }
    ]
}
```

In which **level** attribute has 4 possible values: *FATAL*, *ERROR*, *WARNING*, *INFO*.

This extension also allows customization of error messages and offers a way
to configure and throw Business Exceptions in Gluon format.

## How to use

### Add extension to the project pom.xml

``` { .xml .copy}
<dependency>
    <groupId>com.santander.photon</groupId>
    <artifactId>photon-quarkus-error-handler</artifactId>
</dependency>
```

### Business Exception

The first step is to create an enum implementing ErrorCode interface. This enum
should contain *key*, which is a **String** representing the name of the error and *status*,
which is a **Response.Status** representing the http code that will be returned in response.

Example class:

``` { .java .copy }
public enum AppTestErrorCode implements ErrorCode {
    BUSINESS_ERROR_CODE_ONE("error.one", Response.Status.INTERNAL_SERVER_ERROR),
    BUSINESS_ERROR_CODE_TWO("error.two", Response.Status.BAD_REQUEST);

    private final String key;

    private final Response.Status status;

    AppTestErrorCode(String key, Response.Status status) {
        this.key = key;
        this.status = status;
    }

    @Override
    public String getKey() {
        return key;
    }

    @Override
    public Response.Status getStatus() {
        return status;
    }
}
```

Then a property file containing the capability to customize fields values should be created in
*resources/errors* folder of the project with prefix *error*. The names of the properties should be in
the format *key*.*field-name*=*value*

Example:

``` { .java .copy .title=error.properties }
error.one.code=customized code
error.one.message=customized message
error.one.level=warning
error.one.description=customized description
```

Now, a business exception can be thrown using the enum created. Example:

``` { .java .copy }
throw new BusinessException(AppTestErrorCode.BUSINESS_ERROR_CODE_ONE);
```

### Constraint Validation Exception

Constraint validation exceptions are handled automatically and the messages can't be
customized. The response *description* field will contain details of the field and the violations messages.

Example of response generated:

``` { .json .copy}
[
    {
        "code": "400",
        "message": "Constraint violation exception",
        "level": "ERROR",
        "description": "[{\"field\":\"demo.testEntity.description\",\"message\":\"should not be empty\"},{\"field\":\"demo.testEntity.name\",\"message\":\"should not be empty\"}]"
    }
]
```

### Customize Others Exception Types

Others exceptions messages can be customized by creating properties files in
*resources/errors* folder with *error* prefix containing properties in the following format:
*full-package-name*.*field-name*=*value*. For example, to customize messages of
*jakarta.ws.rs.NotFoundException*, the **error.properties** file should have fields like:

``` { .txt .copy }
jakarta.ws.rs.NotFoundException.code=1234
jakarta.ws.rs.NotFoundException.message=Resource not found
jakarta.ws.rs.NotFoundException.level=error
jakarta.ws.rs.NotFoundException.description=The requested resource was not found
```
