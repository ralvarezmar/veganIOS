---
title: Exceptions Management
hide:
  - toc
---

An exception is a waiver granted for a predetermined period of time that allows for a specific Gluon application to deploy to production even if the automated quality or security checks fail (including SonarQube, Fortify and others).

The purpose of these exceptions is to allow teams to deploy critical fixes or security updates even when the QA or security requirements are not met.
The team commits to fixing whatever quality or security issues are bypassed by an exception before the next release.

All kinds of waiver can only be created or requested by the Application Owner role and the QA and Testing Teams of that company unless a Cross Team association request has been made to also allow members of that team to manage them.

- **Quality exception**: This type of exception allows you to merge PRs in Github to main, and to deploy the application to production, even if the quality workflow fails.
- **Security exception**: This type of exception allows you to merge PRs in Github to main, and to deploy the application to production, even if the security workflow fails.
- **Incidence exception**: This type of exception allows you to merge PRs in Github to main, and to deploy the application to production, even if the quality or security workflows fail. It requires an active P3 or higher incidence registered in ITSM.
- **Testing exception**: This type of exception allows you to merge PRs in Github to main, and to deploy the application to production, even if the integration testing workflow (e.g. Gluon Testing) fails.
- **Cross Team request**: This request allows members of a certain Team to manage exceptions of a certain type. Only applies to Quality and Testing exceptions.

<div class="cards row-3" markdown>

- #### General Usage

    ---
    General use instructions for the exceptions list screen, including the use of searching and filtering functionality.

    [:material-arrow-right: General Usage](./general-usage.md){ .md-button }

- #### Creating Quality Exceptions

    ---
    Create a waiver in order to bypass fails in the quality workflow step.

    [:material-arrow-right: Creating Quality Exceptions](./quality-exceptions.md){ .md-button }

- #### Creating Security Exceptions

    ---
    Link an existing Service Now security waiver to your Gluon application in order to bypass fails in the security workflow step.

    [:material-arrow-right: Creating Security Exceptions](./security-exceptions.md){ .md-button }

- #### Creating Testing Exceptions

    ---
    Create a waiver in order to bypass fails in the integration testing step.

    [:material-arrow-right: Creating Testing Exceptions](./testing-exceptions.md){ .md-button }

- #### Creating Incidence Exceptions

    ---
    Link an existing Service Now incidence (P3 priority or higher) to your Gluon application in order to bypass fails in the quality and security workflow steps.

    [:material-arrow-right: Creating Incidence Exceptions](./incidence-exceptions.md){ .md-button }

- #### Requesting a new Cross Team association

    ---
    Request a certain Cross Team to be allowed to manage a certain kind of exceptions.

    [:material-arrow-right: Requesting a new Cross Team association](./cross-team-request.md){ .md-button }

</div>
