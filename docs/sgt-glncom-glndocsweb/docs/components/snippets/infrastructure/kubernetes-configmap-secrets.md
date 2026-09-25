You have to request the following infrastructure resources.

- Registry
    - Project: You need a project in the registry (**Harbor**, **Artifactory**, **ECR**, and **ACR**) to upload your image.
    - Credentials: **user/password** with privileges to upload images to the project.
- Kubernetes
    - Namespace: You need a **namespace** in the **Kubernetes cluster** to deploy your microservice in the CERT, PRE and PRO environments.
    - Credentials: **Service Account** with the credentials to deploy in the namespace.
