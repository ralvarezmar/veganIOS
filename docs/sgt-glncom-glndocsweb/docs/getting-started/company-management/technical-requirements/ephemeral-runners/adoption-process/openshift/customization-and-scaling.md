---
Title: OpenShift Customization and Scaling
---

#### Creating the RunnerDeployments and HorizontalAutoscallers

- This part is much more configurable and the examples shown are the most basic implementation of the runners. For any further configuration change, please refer to the official actions-runner-controller documentation: [ARC](https://github.com/actions/actions-runner-controller)

- Currently helm chart support for mass and configurable deployments are in [this repository](https://github.com/santander-group-gluon/gln-plat-arc-deployment-helm) Organization Owners need to request reader access using the following link.  
[TECHNICAL CATALOG -> Cloud -> Gluon -> Gluon Tools Request](https://santander.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_category_view.do%3Fv%3D1%26sysparm_parent%3D257db34f1bf2a510e4909753b24bcb38%26sysparm_ck%3Da49421c987fe39104cedea030cbb35f424a3bdc6e2efad83e7317a21ff2d380888b4a989%26sysparm_processing_hint%3Dsetfield:request.parent%3D%26sysparm_catalog%3D719aafd0db031f448c6c7cde3b9619f8%26sysparm_catalog_view%3Dcatalog_technical_catalog)

- We need to do these steps for each pair of organization-namespace as well as step 2 for each kind of runner we want available for the organization.

- We will need these variables to apply this configuration:

< ORGANIZATION_NAME > - Name of the target organization where the ephemeral runners will be available to use.  
< GITHUB_APP_INSTALLATION_ID > - Installation id of the given GitHub App for the given Organizatio.  
< SECRET_NAME_FOR_ORGANIZATION > - Name of the secret with the GitHub App credentials for this organization.  
< ORG_NAMESPACE > - Namespace where the organization will host the runners.  
< RUNNER_IMAGE > - Image to use for the deployed runners.  
< LIST_OF_RUNNERS > - List of labels to apply to the runners to use in the workflows.  

- In the proposed namespace for each organization, we create the secret controller-manager-<ORG_NAME>

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <SECRET_NAME_FOR_ORGANIZATION>
  namespace: <ORG_NAMESPACE>
data:
  github_app_id: <GITHUB_APP_ID>
  github_app_installation_id: <GITHUB_APP_INSTALLATION_ID>
  github_app_private_key: >-
<GITHUB_APP_PRIVATE_KEY>
type: Opaque
```

We add the other requisites for the namespace:

- Resource Quotas, Storage Quota. In this object, we need to increase the storage quota to be able to create the PVCs. Each cluster and namespace can have different configurations, so we only show the specific line to be configured

```yaml
.spec.hard."requests.storage"= "50Gi"
```

- Limit Range. In this object, we need to.

```yaml
.spec.limits.[0].max.memory= "6Gi"
.spec.limits.[1].default.memory= "6Gi"
.spec.limits.[1].max.memory= "6Gi"
```

- PVCs for maven and npm cache. This dependendant on the technology used for the runner.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: maven-cache
  namespace: <ORG_NAMESPACE>
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 15Gi
  storageClassName: shared-gold
  volumeMode: Filesystem
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: npm-cache
  namespace: <ORG_NAMESPACE>
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 30Gi
  storageClassName: shared-gold
  volumeMode: Filesystem
```

- We apply the configuration for the runner deployment and the horizontal autoscaler. Persistent Volume Claim names should match the runner technologies and the names of the PVCs created before.

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: runnerdeploy-1
  namespace: <ORG_NAMESPACE>
spec:
  replicas: 1
    metadata:
      annotations:
        io.kubernetes.cri-o.TrySkipVolumeSELinuxLabel: "true"
    spec:
      runtimeClassName: selinux
      organization: <ORGANIZATION_NAME>
      image: <RUNNER_IMAGE>
      terminationGracePeriodSeconds: 15
      dockerEnabled: false
      serviceAccountName: podman
      imagePullPolicy: IfNotPresent
      githubAPICredentialsFrom:
        secretRef:
          name: <SECRET_NAME_FOR_ORGANIZATION>
      labels:
        - <LIST>
        - <OF>
        - <LABELS>
      env:
        - name: HTTP_PROXY
          value: "http://proxyapp.cloudcenter.corp:8080"
        - name: HTTPS_PROXY
          value: "http://proxyapp.cloudcenter.corp:8080"
        - name: RUNNER_FEATURE_FLAG_EPHEMERAL
          value: "true"
        - name: RUNNER_ORG
          value: "<ORGANIZATION_NAME>"
        - name: RUNNER_LABELS
          value: "test-runner"
        - name: RUNNER_EPHEMERAL
          value: "true"
        - name: LC_ALL
          value: en_US.UTF-8
      volumeMounts:
      - name: maven-volume
        mountPath: /home/runner/.m2/repository
      - name: npm-volume
        mountPath: /home/runner/.npm/_cacache
      volumes:
      - name: maven-volume
        persistentVolumeClaim:
          claimName: maven-cache
      - name: npm-volume
        persistentVolumeClaim:
          claimName: npm-cache
      securityContext:
        runAsUser: 1000

apiVersion: actions.summerwind.dev/v1alpha1
kind: HorizontalRunnerAutoscaler
metadata:
  name: runner-deployment-autoscaler-1
  namespace: <ORG_NAMESPACE>
spec:
  githubAPICredentialsFrom:
    secretRef:
      name: <SECRET_NAME_FOR_ORGANIZATION>
  maxReplicas: 10
  minReplicas: 1
  metrics:
    - scaleUpThreshold: "0.75"
      scaleDownThreshold: "0.25"
      scaleUpFactor: "2"
      scaleDownFactor: "0.25"
      type: PercentageRunnersBusy
  scaleTargetRef:
    kind: RunnerDeployment
    name: runnerdeploy-1
```

Again, for this part, you can just repeat with the proper data these steps as needed.

In case of wanting to select the node group, you can add these lines in the RunnerDeployment:

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: runnerdeploy-1
  namespace: <ORG_NAMESPACE>
spec:
  replicas: 1
    metadata:
      annotations:
        io.kubernetes.cri-o.TrySkipVolumeSELinuxLabel: "true"
    spec:
      runtimeClassName: selinux
      nodeSelector:
        <NODEGROUP_LABEL_KEY>: <NODEGROUP_LABEL_VALUE>
```

Here we only add and can modify:

- `NODEGROUP_LABEL_KEY`: this is the key for the label to use. We use `work_type` for this.
- `NODEGROUP_LABEL_VALUE`: this is the value of the previous key to define which node group to use. We use `Gluon-ephemeral`.

We can use any number of key:values used in these labels.

### NOTE

Remember, if you are using your own infrastructure, you have to use the [following labels on your runners.](../../flavours.md#mandatory-labels)

### Other sections in OpenShift adoption process

<div class="cards row-2" markdown>

- #### OpenShift Installation

    ---
    Install runners in an OpenShift infrastructure

    [:computer: OpenShift Installation](./installation.md/)

- #### OpenShift ephemeral runners administration and maintenance

    ---
    OpenShift ephemeral runners administration and maintenance

    [:question: Administration and Maintenance](./administration-and-maintenance.md/)

</div>
