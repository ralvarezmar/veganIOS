# Principles

This architecture pattern aims to **shorten the development lifecycle** and
**reduce the Time-To-Market** of new functionalities since the **changes are
made on a smaller scale**, with **independent teams & lifecycles** and requiring
**only the deployment of affected pieces** and not the app as a whole.

In this sense, an architecture based on Microfronts must have the following
principles:

- The MFE has **no entity by itself** and will always be offered to the user
  **integrated into an application** called Shell.
  - The Shell could be a **web or a mobile** app.
  - The Shell should integrate the MFEs in a **framework-agnostic way** but must
    take into account the libraries they need (if any).
  - The MFEs must be **designed** and **implemented** in such a way that have
    their own lifecycle (development, testing & deployment) and can be
    integrated at compile or execution time (as a first step, we will only have
    execution time) in **different Shells** and **different platforms** (web & mobile).
  - An MFE must **belong** and **be developed** by the **same team** belonging
    to the **same functional domain** as their backends. This is, an MFE is not
    meant to be developed by different teams.
  - The MFE will **never get its data directly** from a microservice, it must
    always go **through an API**.
  - The MFE must provide a **clear and well-defined contract** that ensures
    proper communication between Shell & MFEs. This is, the inputs and outputs
    and other things like the URL it is deployed in or the dependencies it needs.
- Both the Shell and the MFEs must **follow the same structural guidelines** for
  security, configuration, and monitoring
- **Not all types of applications are suitable** for the use of a MFE
  architecture.
- **Not all development teams are suitable** for developing applications under an
  MFE architecture. The development team **must be mature** and possess the
  appropriate knowledge and skills since the complexity of this type of
  architecture is remarkably greater than a more classical approach.
