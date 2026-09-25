---
hide:
  - toc
---

# Arsenal Integration Documentation {!include-markdown '../snippets/versions.md' start='<!tag:int-version-schema>' end='<!end:int-version-schema>'!}

{!include-markdown '../snippets/versions.md' start='<!tag:int-current>' end='<!end:int-current>'!}

Welcome to the Arsenal Integration Documentation!

Here you will find all the patterns and best practices of Arsenal Integration,
framework recommended to build stateless orchestrated Experience APIs and Java
BAAS APIs.

[Quickstart](tutorials/archetype-rest.md){ .md-button .md-button--primary }
[Overview](./about-arsenal-integration.md){ .md-button }

<br>

---

<div class="cards row-auto" markdown>

- ##### Start here

    ---
    [About Arsenal Integration?](about-arsenal-integration.md)

    Not familiar with Arsenal Integration? Check this page to learn more about
    the framework.

    ---

    [Create Arsenal Integration Application](tutorials/archetype-rest.md)

    Start with your first Arsenal Integration application.

- ##### Popular

    ---
    [Create Arsenal Integration Application](tutorials/archetype-rest.md)

    [Using Open API Contract First](how-to-guides/api/openapi-maven-plugin.md)

    ---

- ##### What's new

    ---
    [Observability Configuration](how-to-guides/observability/observability.md)

</div>

---

## Guides

<div class="cards row-auto" markdown>

- ##### Quickstart Arsenal Integration

    ---

    To show some features of the Apache Camel REST component, we will create a
    service exposing the customers endpoint as an input route and redirecting
    all http GET, POST, PUT and DELETE verbs to other internal endpoints
    specific to each operation.

    <br>
    <br>

    ---

    [Start Guide](tutorials/archetype-rest.md){ .md-button }

- ##### Using Open API Contract First

    ---

    A maven plugin was developed that reads a yaml or json file containing
    OpenAPI 3.0 Specification and generates the necessary classes for a Camel
    project with REST exposure from the resources identified in the file.

    <br>
    <br>
    <br>

    ---

    [Start Guide](how-to-guides/api/openapi-maven-plugin.md){ .md-button }

</div>

---

## Related content

[How to create the component from Gluon](../../../../../../../application/component-management/create-component.md)

[Setup your maven local environment](../../../../../../../getting-started/setup-your-environment/technologies/java-maven.md)
<br>
<br>
