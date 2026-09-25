# Darwin-spring-boot-omnichannel Migration guides

## Version 4.1.0-RELEASE

<!tag:410>

- From this version **ContactPoint is not populated with User-Agent info by default**.
This feature has a **high memory cost at start-up**, and we recommend don't use it if it's not necessary.
If you need this feature you can include **com.santander.darwin:darwin-spring-boot-starter-omnichannel-ua-parser** instead on "basic" Omnichannel starter.

<!end:410>

## Version 3.0.0-RELEASE

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- The `spring-webflux` dependency now is included as transient dependency.

- Removed feature to get ContactPoint from RequestContextHolder and removed **ContactPointHelper** class from the **util** package, use **DarwinContextHolder** to obtain ContactPoint.

<!end:300>

## Version 2.9.0-RELEASE

<!tag:290>

- As of this version, the properties *darwin.omnichannel.header* and *darwin.omnichannel.parameter* has changed for:

  | Old                          | New                                  |
  |------------------------------|--------------------------------------|
  | darwin.omnichannel.header    | darwin.omnichannel.header.channel    |
  | darwin.omnichannel.parameter | darwin.omnichannel.parameter.channel |

- Although it is not mandatory, it is advisable to specify the entity to which it belongs on the channel map. For example, if you continue to use the default channel map, it is recommended to set the default entity ("ALL").

Example of the initial load file:

    {
      "ALL" : {
          "OFI": {
            "originChannel": "OFI",
            "marcoChannel": "OFI",
            "environment": "INTRANET",
            "logicalChannel": "0007",
            "physicalChannel": "0019",
            "commercialChannel": "RED",
            "operationalChannel": "RED"
          },
          ...etc...
      },
      "0075": {
          "OFI": {
            "originChannel": "OFI",
            "marcoChannel": "OFI",
            "environment": "INTRANET",
            "logicalChannel": "0007",
            "physicalChannel": "0019",
            "commercialChannel": "RED",
            "operationalChannel": "RED"
          },
          ...etc...
      }
    }

And if new channels are established through the *darwin.omnichannel.externalChannelMap* property, it is recommended to indicate the entity or, failing that, "ALL".

For example, to overwrite one or more values in the default entity:

    darwin:
      omnichannel:
          external-channel-map:
            ALL:
                OFI:
                  marco-channel: OFI_W
                  environment: INTRANET_Z

or for a specific entity:

    darwin:
      omnichannel:
        external-channel-map:
          "0075":
                OFI:
                  marco-channel: OFI_W
                  environment: INTRANET_Z

<!end:290>
