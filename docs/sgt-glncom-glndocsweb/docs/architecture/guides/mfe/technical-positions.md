# Technical Positions

Gluon's technical positions about a microfront architecture are:

- **Polygloth architecture**, with Angular & React as base frameworks.
- **Hybrid approach**, where the same Microfront is integrated within a web or a mobile Shell, offering the same experience for different channels.
- **Develop once** and offer **different types of integration**:

     - MFE integrated within the **same DOM** tree of the Shell (for web).
          - As a **federated module** (Darwin flavor)
     - MFE integrated through an **iframe** in the Shell (for web)
          - Only for exceptional cases where integration into the same dom tree is not possible
     - MFE integrated through a **webView** in the Shell (for mobile)

!!! note
    In **this Gluon version we only offer support for Angular**, but we are working to offer React support in future versions. Same for Web/Mobile. **This Gluon version is focused on Web** but we are working to offer Mobile support as soon as possible.

## When to use this architecture?

It is an optimal pattern for the development of **large applications**, with a
**long life ahead** and developed by **different teams** working in parallel and
independently.

Here, the **main challenge** will be to correctly **segregate** the application
features **into several MFEs**.

## When NOT to use this architecture?

It is **not recommended** for carrying out **prototypes**, **proofs of concepts**
or **small applications** with a **short scope in time** or developed
by a **single development team**.

## How to segregate Microfronts into repositories and development teams?

There is **no standardized way** since it will depend a lot on the type of
project and the development squads that exist in it.

There would be certain **guidelines** to follow:

- **Shell** development:

     - Should be in an **independent repo** from the MFEs
          - This way, it will be deployed in an independent nginx
     - Developed by a team **focused on**:
          - **Integrate** and **communicate** the different MFEs **acting as a controller** between them
          - Provide the **security** mechanisms to the MFEs ecosystem

- **MFE** development:
     - They should be segregated by functional domains
     - In this version, each repo should contain only **one MFE**
          - It is important to take into account  **each MFE would be deployed in a different** **_nginx_**
