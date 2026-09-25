# Localization

## Localization Files

The default localization files *basename* is **errors/errors**, it can be overwritten by defining
the property **spring.messages.basename** in **application.yml**. Localizations files will be searched
within the project **resources** folder if **spring.messages.basename** has format **classpath:basename**
and external file path can also be specified by using the
following pattern: **file:path-to-folder/basename**

## Customize Error Messages

The first step is to include *gln-back-arsenal-integration-core-starter* dependency:

``` { .xml .copy }
<dependency>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-integration-core-starter</artifactId>
</dependency>
```

Error message is chosen based on the following parameters:

* *entity*: request **organization** header
* *channel*: claim "channel_tp" of the JWT or the request "X-appname" header
* *locale*: request **Accept-Language** header
* *exception*: custom error message key
* *field*: one of the four gluon error format fields: code, description,
level (FATAL, ERROR, WARNING, INFO) and message.
If *code* is not set, the http status code will be used instead. If *message* or *description*
is not set, the original message error will be used. The default error *level* is ERROR;

Assuming the default basename configuration is used, to customize an error message, create a file
**errors_\[LanguageCode\]_\[CountryCode\].properties** inside resources/errors folder. Then define
error messages using the following pattern: channel.entity.exception.field=error_message. Example:

``` { .properties .copy }
AEAM3.santander.not_found.message=not found error message
AEAM3.santander.not_found.code=130
AEAM3.santander.not_found.description=not found error description
AEAM3.santander.not_found.level=FATAL
```

Then set an exchange property with "ErrorCode" as key and the defined error message key
as the value in the catch scope. Example:

``` { .java hl_lines="2" .copy}
.doCatch(Exception.class)
    .setProperty("ErrorCode", constant("not_found"))
    .to("direct:defaultErrorRoute").stop()
```

## Custom Validation Annotation Error Messages

To enable bean validation, route to bean validator endpoint before using it:

``` { .java .copy }
    .to("bean-validator://x")
```

Then catch the BeanValidationException and send to **beanValidationRoute** route:

``` { .java .copy }
    .doCatch(BeanValidationException.class)
        .to("direct:beanValidationRoute").stop()
```

Validation error messages can be customized by defining custom messages inside localization files
in this pattern: validator.attribute=Error Message

Example:

``` { .properties .copy }
jakarta.validation.constraints.NotNull.attributename=The attributename cannot be null.
```

Note that the validator full name should be used.

## How the error message is chosen?

The localization message file will be chosen based on the request **Accept-Language** header, if the language isn't supported, the fallback messages will be used. Then if both *channel* and *entity* exist, the message with key in
the format **channel.entity.error** will be chosen. If anyone of the values *channel* or *entity* doesn't
exist or if a message with **channel.entity.error** key doesn't exist, the message with the format
**error** will be used.

## Error Messages Configmap

It's possible to use configmap containing error messages as message source by adding the following
properties in the chart **values.yaml**:

``` { .yaml .copy }
arsenal:
  ## Literal file and internalization configuration
  ##
  i18n:
    ## @param i18n.enabled Enable init container that generates the i18n configuration
    ##
    enabled: false
    ## @param i18n.path Define the path to store the literal and internalization files
    path: /etc/i18n
    ## @param i18n.prefix Define the internalization files prefix.
    ## If the file name is errors_en.properties, the prefix is errors
    prefix: errors
```

The configmap name should be in the format "i18n-\[fullname\]", in which fullname is the name
defined by **fullnameOverride** property in **values.yaml**.
