
1. Santander APIs are defined in the global API Catalog, with a global definition and local/ global implementation (depending on the backend).
    1. No local endpoints are allowed. Local data extensions within an endpoint are allowed.

2. All APIs must be published in the API gateways established by the Group, using the pipelines defined in the Gluon Platform.

3. All APIs will evolve using the local/global governance model automated in Gluon to ensure a global standard with the right local requirements.
    1. New APIs or updates to existing ones could be proposed by any of the API community members.
    2. Approval of the API/ updates should be approved by the community through the mechanisms provided by Gluon.
    3. New APIs implemented by countries must be the latest version of the API published on the global API Catalog.
    4. Gluon must enforce the alignment of the implementation with the definition through the pipeline.

4. API implementations (local/global) must use the last version defined in the Global Catalog. It’s a responsibility of the local/global API consumers to be aligned with the last version as soon as they can.
    1. **Major versions:** Only two major versions can coexist. Three versions could coexist for a maximum period of 3 months. For a major version, API Owners need to make sure that there are no calls (subscriptions) and that the subscribers are informed.
    After that, the API must be deprecated.
    2. **Minor Versions:** Only one minor version can exist. If there is a new minor version, API Owners must first migrate subscribers to the new minor version, and after that they can be declared obsolete.

5. Authorization would be moved to the API layer for all the backends (Gravity+, Lean the core, Global platforms).
    1. All APIs must adhere to the security model for exposed endpoints defined in the Global Security Architecture.
    2. Every new API update or creation must include a security profiling process owned by the local/global security architect.

6. All APIs must be managed using a standard operating model for all the Group:
    1. New/Update API request are governed by the local/global API architect (reports to the local/global CTO). All the requests should be reviewed/ approved by him. Key decisions should include:
        - Do we need a new API or should we reuse an existing one?
        - If a new API is needed, which API defined in the global catalog we should leverage?
        - Do we need some adjustments in the last version of the API defined in the global catalog?

    2. All the API designers report to the local API architect, even if they are assigned to the different domains to ensure closeness with the backend owners.
    3. All API Proposals will need to be submitted to the Global API Governance Team (lead by Global Head of APIS, reporting to the Global CTO) for approval.

7. Only one API to connect front-ends with back-ends is the default model. Any exception to the model must be explicitly sustained by a Solution Design and approved by the local/global API architect.
