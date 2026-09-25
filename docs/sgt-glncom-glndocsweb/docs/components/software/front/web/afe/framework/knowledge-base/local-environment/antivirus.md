# How to troubleshoot antivirus-related issues?

## Contextualization

Some developers may encounter problems executing the 'npm install' command, in view of the fact, we recommend opening a request in [Service Now](https://santander.service-now.com/) to configure the anti-virus rule.

Freeing the **node_modules** folder from being analyzed by the program.

## Solution

- In the side menu (located in the left corner of the page), navigate through the links described below:
  - Service Catalog
  - Technical Catalog
  - Cybersecurity
  - EndPoint Security
  - SECURITY - Antivirus - Installation or Configuration
- In the request form, fill in the fields below as follows:
  - **Short Description**: Inclusion in Developer Rule
  - **Description**: Please include my user: user and machine: hostname in the developer policy, with antivirus clearance for node_modules.

> Don't forget to replace your user and machine in the description.
> After the task is completed by the security team, your machine must be restarted for the policy to be applied.
