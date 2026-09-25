---
title: Validations
hide:
  - toc
---

## Topic schema validation

One of the controls applied is validate the topics schema file. For that, the file ``topics_[ENV].yml`` must be present in the folder ``src/config/[env]/topics`` (env and ENV depends on the environment, for instance: ``src/config/cert/topics/topics_CERT.yaml``).

In this file, we execute a validator tool, where we check if every defined rule for the general structure of all the topic schema files are correct. Here we will show the different validations are applied:

### Topic name and context

| Fields                   | Definition                | Mandatory | Validations                                                                               |
|--------------------------|---------------------------|-----------|-------------------------------------------------------------------------------------------|
| ``context``              | Project's entity          | YES       | <ul><li>Must be in capital letters</li><li>Must be one of the companies 3-letters acronym </li></ul>                                    |
| ``projects.name``        | Project's appkey          | YES       | <ul><li>Must match the regex pattern ``^[A-Z0-9]*$`` (Only capital letters and digits accepted)</li></ul>  |
| ``projects.topics.name`` | Name to create topic name | YES       | <ul><li>Must match the regex pattern ``^[A-Z0-9]*$`` (Only capital letters and digits accepted)</li></ul>  |

???+ info "Note"
    The final topic name is formed with ``[context].[projects.name].[projects.topics.name]``

### Topics config (``project.topics.config``)

This field has no fixed subfields, it’s a ``Map<String, Object>`` field, you can custom all the properties you need. The following properties will be validated:

| Fields                   | Definition                | Mandatory | Validations                                                                               |
|--------------------------|---------------------------|-----------|-------------------------------------------------------------------------------------------|
| ``num.partitions``              | Number of topic partitions          | YES       | <ul><li>Must be an Integer</li><li>Cannot be greater than 20 (if you need it you can request special permission to Big Data team)</li></ul>                                    |
| ``retention.ms``        | Project's appkey          | YES       | <ul><li>Must be an Integer</li><li>Cannot be greater than 604.800.000 (7 days) (if you need it you can request special permission to Big Data team)</li></ul>                 |

???+ warning "Note"
    Also we validate that the field ``min.insync.replicas`` **DOESN’T EXIST**. Its value is defined by default by Big Data team. If you need to change it you can request special permission to them.

### Topic Schemas (``project.topics.schemas``)

| Fields                   | Definition                | Mandatory | Validations                                                                               |
|--------------------------|---------------------------|-----------|-------------------------------------------------------------------------------------------|
| ``value.schema.file``              | Path to file with the schema | Only if: <ul><li>schemas section exist</li><li>OR ``projects.topics.metadata.topicType`` is not ``Local - Application``</li></ul> | The file exists (will be located in event definition repository) |
| ``value.compatibility``        | Schema compatibility type    | Only if: <ul><li>schemas section exist</li><li>OR ``projects.topics.metadata.topicType`` is not ``Local - Application``</li></ul> | Depending on ``projects.topics.metadata.topicType`` must be; <ul><li>``COMMAND`` --> ``BACKWARD_TRANSITIVE``</li><li>``EVENT`` --> ``FORWARD_TRANSITIVE``</li><li>``EVENT`` and ``projects.topics.metadata.topicCDCSource`` not null or ``""`` --> ``FULL_TRANSITIVE``</li></ul>  |

### Topic Producers (``project.topics.producers``)

| Fields                   | Definition                | Mandatory | Validations                                                                               |
|--------------------------|---------------------------|-----------|-------------------------------------------------------------------------------------------|
| ``principal``              | Principal to give production permissions. It must be a User or a Group: <ul><li>``User:<apl-user>``</li><li>``Group:<apl-group>``</li></ul>          | YES       |            |

### Topic Consumers (``project.topics.consumers``)

| Fields                   | Definition                | Mandatory | Validations                                                                               |
|--------------------------|---------------------------|-----------|-------------------------------------------------------------------------------------------|
| ``principal``              | Principal to give consumer permissions. It must be a User or a Group: <ul><li>``User:<apl-user>``</li><li>``Group:<apl-group>``</li></ul>          | YES       |            |

### Topic Metadata (``project.topics.metadata``)

| Fields                   | Definition                | Mandatory | Validations                                                                               |
|--------------------------|---------------------------|-----------|-------------------------------------------------------------------------------------------|
| ``eventExample``              | File with an event example | Only if: <ul><li>``projects.topics.metadata.topicType`` is not ``Local - Application``</li></ul> |  <ul><li>The value is not null and is not blank</li></ul>           |
| ``topicPlatform``              | Platform where the topic is | YES       |  <ul><li>Must match ``OnPremise``or ``Azure``</li></ul>           |
| ``topicStatus``              | Status topic    | YES       |  <ul><li>Must match ``Active`` or ``Deprecated``</li></ul>           |
| ``topicCDCSource``              | Source table of CDC where topic came from    | NO       |  |
| ``topicAsyncApiFile``              | File with AsyncAPI specification | Only if: <ul><li>``projects.topics.metadata.topicType`` is not ``Local - Application``</li></ul> |  <ul><li>The file exists</li></ul>           |
| ``applicationId``              | | NO | |

## AsyncApi validation

### AsyncApi Fields

| Fields                      | Definition                |
|-----------------------------|---------------------------------|
| ``x-company``               | Company ID |
| ``x-scope``                 | Area where the event applies |
| ``x-type``                  | Indicates the Typology, it can be **EVENT** or **COMMAND** |
| ``x-format``                | Event definition format can be **JSON** or **AVRO** |
| ``x-confidentialData``      | Indicates the level of privacy of the Event data|
