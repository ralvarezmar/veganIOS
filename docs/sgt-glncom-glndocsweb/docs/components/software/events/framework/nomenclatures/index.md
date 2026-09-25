---
title: Nomenclature
hide:
  - toc
---

This document provides guidelines for naming conventions in different parts of the Events Journey.

## Event Name

To define an **event name**, a structured nomenclature is used based on the type (Event or Command) and its scope. The naming convention includes specific tags to ensure clarity and consistency:

* **BIAN SERVICES DOMAIN**: The services domain responsible for the Event/Command.
* **ACTION**: A verb describing the action or fact about the resource, conjugated in the present or past tense depending on the context.
* **ENTITY**: The entity associated with the event.
* **APPID**: A unique identifier for the application responsible for the Event/Command.

The table below outlines the classification, scope, and naming conventions for schema and topic naming:

| Classification | Scope       | Category           | Event Naming                                         | Topic Naming                                      |
|----------------|-------------|--------------------|------------------------------------------------------|---------------------------------------------------|
| Event          | Local       | Application        | `[APPID].[BIAN-SERVICES-DOMAIN].[ACTION-PAST]`       | `[ENTITY].[APPID].[RESOURCE].[ACTION-PAST]`       |
| Event          | Local       | Domain or Entity   | `[BIAN-SERVICES-DOMAIN].[ACTION-PAST]`               | `[ENTITY].[APPID].[RESOURCE].[ACTION-PAST]`       |
| Event          | Global      | Global             | `[BIAN-SERVICES-DOMAIN].[ACTION-PAST]`               | `[ENTITY].[APPID].[RESOURCE].[ACTION-PAST]`       |
| Command        | Local       | Application        | `[APPID].[BIAN-SERVICES-DOMAIN].[ACTION-INFINITIVE]` | `[ENTITY].[APPID].[RESOURCE].[ACTION-INFINITIVE]` |
| Command        | Local       | Domain or Entity   | `[BIAN-SERVICES-DOMAIN].[ACTION-INFINITIVE]`         | `[ENTITY].[APPID].[RESOURCE].[ACTION-INFINITIVE]` |
| Command        | Global      | Global             | `[BIAN-SERVICES-DOMAIN].[ACTION-INFINITIVE]`         | `[ENTITY].[APPID].[RESOURCE].[ACTION-INFINITIVE]` |

> **Note**: The topic naming conventions provided above are recommendations and are not currently enforced by any rules. The team is actively evaluating use cases across the organization to determine the necessary validations for standardization.
