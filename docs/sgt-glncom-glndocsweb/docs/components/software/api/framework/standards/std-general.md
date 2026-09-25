# General Standards

1. Santander Group API MUST provide a set of functionalities, and they MUST have implemented a Sandbox service AND a Live service.
2. Santander Group API MUST be implemented as a REST service.
    - Santander Group API MUST have identified resources.
    - HTTP Verbs MUST be used correctly in resources to cover functionalities identified.
    - Hypermedia Controls HATEOAS SHOULD be used.
3. API MUST be managed to control APIs lifecycle.
      - API MUST be placed in Gluon Developer Portal (more agility and independence).
      - API MUST take part of Gluon APIs Catalog.
      - API MUST have a control version.
      - API consumption MUST be managed by app credentials management, consumption plans managements, subscription and API visibility.
4. Santander Group API MUST be defined for any consumer or exposition.
    - API MUST be performed with a **360-degree product vision** focused on the API's consumer.
    - APIs MUST be defined top-down, starting from the business vision and ending with the technical definition.
    - An API MUST have only one Group definition which can be consumed or exposed in different scenarios.
    - The functionality exposed by Santander APIs MUST be the same in all entities. Its interface MUST be uniform as defined by the REST architectural style.
5. Santander Group API MUST be designed to enable self-service
      - Santander Group APIs MUST be consumed by applications without any contact with API Owner.
      - APIs MUST be well documented including functional and technical documentation.
6. Santander Groups API MUST be defined in OpenAPI Specification 3.0.x and the file extension for API specification documents MUST be **.yaml**.
7. Santander Group API MUST be designed and implemented in English language.
8. Santander Group APIs MUST NOT return Santander internal codes in API Responses.
