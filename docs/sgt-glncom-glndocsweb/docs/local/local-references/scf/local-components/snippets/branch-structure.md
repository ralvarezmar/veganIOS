<!--Start Branch Structure-->
When you create a component from the Gluon Portal, the component is initialized with the default values provided by the scaffolding workflow.
This process sets up the foundational structure for your microservice, ensuring that you have a consistent starting point for development.

The scaffolding workflow performs the following actions:

* **Creates an empty main branch**:
    The main branch is created as an empty branch. This branch serves as the primary branch for your project, where stable and production-ready code will eventually reside.
    This branch will only contain required workflows.

* **Creates a development branch**:
    The development branch is created with a predefined structure of files and folders. This structure includes all the necessary configurations and scripts required to run your component.
    The development branch is where the initial development and integration work takes place.

* **Feature branch**:
    From the development branch, you can create feature branches. Feature branches are used for developing new features or making changes to the codebase.
    Each feature branch is derived from the development branch, allowing you to work on new features in isolation. Once the feature is complete and tested, it can be merged back into the development branch.

By following this branching strategy, you can maintain a clean and organized codebase, facilitating efficient development and collaboration.

<!--End Branch Structure-->
