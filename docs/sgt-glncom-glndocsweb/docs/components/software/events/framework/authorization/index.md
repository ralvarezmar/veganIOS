---
title: Authorization
hide:
  - toc
---

In this section you will find all the details about the authorization method used in Events.

## Group naming

In order to control permissions, different groups will be used. The syntax of all the groups are the same, but a couple of values are dynamic:

* **[COMPANY]**: This value will be the 3-letters acronym of the company.
* **[APPKEY]**: This value will be the acronym of the application.

Here we have a summary table with the possible environments, the name of the groups, and the permissions given based by the topic pattern (**RW** will be Read & Write permission, **R** will be only Read permission):

???+ warning "Warning"
    Although in the future this steps will be automated, right now these groups are needed to be created manually in order to allow that server will be able to give the proper permissions.

| Name                                   | DEV                         | PRE                         | PRO                         |
|----------------------------------------|-----------------------------|-----------------------------|-----------------------------|
|                                        | **grp_[APPKEY]_dev**        | **grp_[APPKEY]_pre**        | **grp_[APPKEY]**            |
| **TOPIC**                              |                             |                             |                             |
| [COMPANY].[APPKEY].*                   | RW                          | RW                          | RW                          |
| **SCHEMA REGISTRY**                    |                             |                             |                             |
| [COMPANY].*                            | R                           | R                           | R                           |
| [COMPANY].[APPKEY].*                   | RW                          | RW                          | RW                          |
