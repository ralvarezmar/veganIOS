# Error Localization

This is a guide about error localization (l10n) and internationalization (i18n) configurations and usages.

!!! warning

    Check Photon Error Handler documentation to know more about error handling and configuration.

## How the localization bundle is chosen

The localization bundle is chosen based on **Accept-Language** header, if there's no available language bundle for
the requested language(s), the default one will be used.

## Change default basename

The default basename is **errors/error**. To change its value, set the value of property **photon.error.bundle.basename** to the desired basename.

Example:

``` { .txt .copy }
photon.error.bundle.basename=test/error
```

## Channel And Entity Fields Usages

It's possible to configure bundle messages based on **channel** and **entity** using the following pattern:
*channel*.*entity*.*errorcode*.*field* for business exceptions and *channel*.*entity*.*full-package*.*field* for other exceptions.

Example:

``` { .txt .copy }
channel.entity.error.one.code=entity channel code
channel.entity.error.one.message=entity channel message
channel.entity.error.one.level=error
channel.entity.error.one.description=entity channel description
```

Then it's necessary to include the following dependencies in the pom.xml:

``` { .xml .copy }
<dependency>
    <groupId>com.santander.photon</groupId>
    <artifactId>photon-quarkus-core-contexts</artifactId>
</dependency>

<dependency>
    <groupId>com.santander.photon</groupId>
    <artifactId>photon-quarkus-channel-filter</artifactId>
</dependency>

<dependency>
    <groupId>com.santander.photon</groupId>
    <artifactId>photon-quarkus-entity-filter</artifactId>
</dependency>
```

Finally, to be able to use these messages, the request should be sent
with *channel* and *organization* fields.

*Organization* field will be the value of header *organization*
and *channel* field will be retrieved in the following way:
If **photon.jwt.channeltp.enabled** is set to *true* in **application.properties**,
it will be the value of JWT *channel_tp* claim. Otherwise, it will use
the value of *X-Appname* header or *X-Santander-Channel* header.

Example:

``` { .sh .copy }
curl --location 'localhost:8080/api/v1/tests' \
--header 'X-Appname: channel' \
--header 'organization: entity'
```

!!! warning

    If one of the *channel* and *entity* value is not available in the headers, the default message without
    channel and entity will be used.
