You have to request the following infrastructure resources.

### Registry

- Project: You need a project in the registry (**Harbor**, **JFrog** or **ECR**) to upload your image
- Credentials: **user/password** with privileges to upload images to the project

### Kubernetes

- Namespace: You need a **namespace** in the **Kubernetes cluster** to deploy your image in the CERT, PRE and PRO environments
You can create your namespace in Gluon following [this guide](../../../../configuration/kubernetes/namespace_harbor.md)
- Credentials: **Service Account** with the credentials to deploy in the namespace

### Configmaps

- **Configuration** Configmap: You may need a configmap in the namespace with your **external environment-dependent configuration**. You can create the configmap component in Gluon following [this guide](../../../../configuration/kubernetes/configmaps-rm.md).

    To **relate this configmap to your component**, it is necessary to define in the `values.yaml` of the **configmap** the variable **applicationName** with value `cm-[component-chart-release-name]`.

    For Example, if your component name is `gln-demo-shell`, the name of the configmap must be `cm-gln-demo-shell`.

### How to configure your deployment environment

{!
   include-markdown "../snippets/snippet-oam.md"
   start="<!--Start Infrastructure-->"
   end="<!--End Infrastructure-->"
!}
