## Entities values validation

Each entity is value is checked against a list of whitelisted entities which is
getted from nexus:

**<https://nexusmaster.alm.europe.cloudcenter.corp/repository/binaries_releases/sgt/ci-cd/com.santander.alm.tool/entities-list/entities-list-1.3.1.zip>**
(in the **whitelist.yaml** file)

If your entity is not included in this list you should contact ALMMC.

In case the destination_entity is not present in the list, a warning is
displayed as follows:

```text
DESTINATION_ENTITY to be sent: UNKNOWN
```

In the case the parameter `destination_entity` is not set, the following
message will be displayed:

```text
DESTINATION_ENTITY to be sent: NOT_DEFINED
```

and the value will be sent to ElasticSearch.

Please Note that in the future we will change to the error level in the case
where the value is 'UNKNOWN' or 'NOT_DEFINED'.
