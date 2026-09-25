---
title: Definitions
hide:
  - toc
---

In this section you will find different definitions about terms related to Events.

## Event/Command

There is several differences between an Event and a Command. Here we present the main ones:

| Event features                         | Command features                       |
|----------------------------------------|----------------------------------------|
| Something that has happened            | It is a command to execute an action   |
| Named in the past                      | Named in infinitive                    |
| 1 to N (1 producer N subscribers)      | N to 1 (N producers 1 subscriber)      |
| No response required (fire and forget) | Usually requires a response            |
| Producer is the owner of the event     | Subscriber is the owner of the command |

???+ info "Change Data Capture (CDC) Events"
    There is a type of particular events that must be considered in a special way. Events produced by CDC. These events meet all the characteristics described above.

    CDC events are those that have a table as their source of information. The objective is to detect changes that occur in the data (insert, update, delete).

## Roles

There are several roles involved in the lifecycle of events. Here we present the main ones:

### Local Head

The Local Head is already explained in this sections [Local Head](../../../events/life-cycle/index.md#local-head).

### Access Management Team

The Access Management Team is responsible for introducing the secrets into Vault. They ensure the secure storage and handling of sensitive data like API keys, passwords, or certificates.

### Developer

The Developer is the one who creates or modifies the definition and implementation of the event. They are responsible for ensuring the event meets the requirements and functions as expected.
