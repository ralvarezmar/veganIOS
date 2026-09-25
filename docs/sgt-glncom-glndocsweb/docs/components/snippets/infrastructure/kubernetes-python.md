You have to request the following infrastructure resources.

### Registry

- Project: You need a project in the registry (**Harbor** , **JFrog** or **ECR**) to upload your image.
- Credentials: **user/password** with privileges to upload images to the project.

### Kubernetes

- Namespace: You need a **namespace** in the **Kubernetes cluster** to deploy your microservice (and other kubernetes components) in the CERT, PRE and PRO environments.
You can create your namespace in Gluon following [this guide](../../configuration/kubernetes/namespace_harbor.md)
- Credentials: **Service Account** with the credentials to deploy in the namespace.

### Configuration

- **Configuration** Configmap: By default, the microservice does not require a configuration file,
  but it's also possible to create a configmap in the namespace with your **external environment-dependent microservice configuration**.
  You can create the configmap component in Gluon following [this guide](../../configuration/kubernetes/configmaps-rm.md)

- **I18n** Configmap: it's also possible to create a configmap in the namespace with **internationzalization values for your microservice**. You can create the configmap component following [this same guide](../../configuration/kubernetes/configmaps-rm.md).

???+ warning "Configmap"

  - **The input parameters required to configure using a configmap vary based on the application**. Visit [Helm documentation](../../software/backend/nodejs/darwin/darwin-node-journey.md#helm-configuration) to know more about.

  - Now the **name of the configmap is customisable**. You can use any name for the secret and configmap. The name of the secret and configmap can be overwritten in the `.gluon/cd/values.yaml` file.

???+ tip "Example of the configmap with environment variables"

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
    name: cm-[microservice-name] or cm-[microservice-applicatioName]
    namespace: [namespace]
data:
    DARWIN_TEST_VALUE: YWRtaW4=
    DARWIN_TEST_VALUE2: MWYyZDFlMmU2N2Rm
```
