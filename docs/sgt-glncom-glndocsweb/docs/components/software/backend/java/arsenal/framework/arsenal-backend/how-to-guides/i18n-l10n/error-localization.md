# Localization

## Localization Files

The default localization files *basename* is **errors/errors**, it can be overwritten by defining
the property **spring.messages.basename** in **application.yml**. Localizations files will be searched
within the project **resources** folder but external file path can also be specified by using the
following pattern: **file:path-to-folder/basename**

## Customize Error Messages

Error message is chosen based on the following parameters:

* *entity*: request **organization** header
* *channel*: claim "channel_tp" of the JWT or the request "X-Appname" header
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
AEAM3.santander.apparsenal.not_found.code=123
AEAM3.santander.apparsenal.not_found.message=AppArsenal was not found message
AEAM3.santander.apparsenal.not_found.level=ERROR
AEAM3.santander.apparsenal.not_found.description=AppArsenal was not found description
```

Then add an entry into \[entity\]ErrorCode enum in **infra/handler/exception** specifying errorCode,
httpCode and message key. Example:

``` { .java .copy }
ERROR_APPARSENAL_NOT_FOUND(1001, HttpCode.NOT_FOUND, "apparsenal.not_found")
```

Finally, an exception with customized message can be created passing the ErrorCode the following way:

``` { .java .copy }
BusinessException(AppArsenalErrorCode.ERROR_APPARSENAL_NOT_FOUND)
```

There are some predefined ErrorCode that can be used for non BusinessException:

Example:

``` { .properties .copy }
# this will overwrite the default no handler found error message field
arsenal.conventions.request.no_handler_found.message=customized no handler error message
```

## Custom Validation Annotation Error Messages

Validation error messages can be customized by defining custom messages inside localization files.
It supports 3 patterns:

* Validator=Error Message

    Example:

    CPF=Invalid CPF.

    Applies to all cases of @CPF that do not have a more specific message registered.

* Validator.attribute=Error Message

    Example:

    NotBlank.attributename=The attributename cannot be blank.

    Applies to all cases of @NotBlank applied to an attribute called 'attributename', regardless of the class.

* Validator.class.attribute=Error Message

    Example:

    NotBlank.classname.attributename=The attributename of the classname cannot be blank.

    Applies to attribute "attributename" of class "classname". "classname" and "attributename" should start with lower case.

## How the error message is chosen?

The localization message file will be chosen based on the request **Accept-Language** header, if the language isn't supported, the fallback messages will be used. Then if both *channel* and *entity* exist, the message with key in
the format **channel.entity.class.error** will be chosen. If anyone of the values *channel* or *entity* doesn't
exist or if a message with **channel.entity.class.error** key doesn't exist, the message with the format
**class.error** will be used.

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
