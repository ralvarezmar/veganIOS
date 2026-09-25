---
title: ALM Documentation
hide:
  - toc
---

In this space you will find user documentation that will help you understand
and guide you step by step on the features offered in GLUON.

<!--
![Welcome to GLUON user documentation](./assets/images/iniciomkdocs.png)

<br>
-->

---

<div class="cards row-auto" markdown>

- ##### Start here

    ---
    CI workflows will allow you to build your application, generate the container
    image and deploy it to a certification environment. We can also leave
    a prepared image in Harbor, Jfrog, EKS, AKS , etc to be able to deploy it later with the
    PRE/PRO workflows.

    Consult the documentation of the different verticals for more details on the CI workflows

    ---

    CD workflows will allow you to deploy your application into
    a preproduction/Production environments.

    Consult the documentation of the different verticals for more details on the CD workflows

- ##### Popular

    ---
    [How to disable a workflow](./howtos/index.md#4-how-to-temporarily-disableenable-a-workflow)

    [Configure environment in repository](./howtos/index.md#1-how-to-configure-an-environment-in-a-github-repository)

    ---

</div>

## Guides

<div class="cards row-auto" markdown>

- ##### Setup secrets in your repository

    ---

    This guide explains how to register a secret in a github.com repository
    and can be consumed from the ALM Nextgen workflows, we will follow the
    next steps.

    <br>

    ---

    [Setup secret](./howtos/index.md#2-secrets-in-githubcom){ .md-button }

- ##### Skip the execution of a workflow

    ---

    It is possible to skip executions of a workflow that is triggered by
    push or pull_request events by including a command when committing.
    Let´s see how.

    <br>

    ---

    [Skip execution](./howtos/index.md#3-how-to-skip
    -the-execution-of-a-workflow){ .md-button }

</div>
<br>
<br>
