---
Title: AWS Customization and Scaling
---

## Customization

Currently helm chart support for mass and configurable deployments are in [this repository](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/) Organization Owners need to request reader access using the following link.  
[TECHNICAL CATALOG -> Cloud -> Gluon -> Gluon Tools Request](https://santander.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_category_view.do%3Fv%3D1%26sysparm_parent%3D257db34f1bf2a510e4909753b24bcb38%26sysparm_ck%3Da49421c987fe39104cedea030cbb35f424a3bdc6e2efad83e7317a21ff2d380888b4a989%26sysparm_processing_hint%3Dsetfield:request.parent%3D%26sysparm_catalog%3D719aafd0db031f448c6c7cde3b9619f8%26sysparm_catalog_view%3Dcatalog_technical_catalog)

Here we are going to describe the values of the values.yaml that required modifications to work with our AWS environment.

### Scaler Set Controller - Values

[Configured Values for Gluon controller](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/inventory/gha-runner-scale-set-controller/values.yaml)

```yaml
labels: {}
replicaCount: 1
image:
  repository: "<ECR_IMAGE_URL>"
  pullPolicy: IfNotPresent
  tag: "<CHART_VERSION>"
imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""
env:
  - name: "http_proxy"
    value: "<HTTP_PROXY>"
  - name: "https_proxy"
    value: "<HTTPS_PROXY>>"
  - name: "no_proxy"
    value: "<NO_PROXY>"
  - name: NODE_EXTRA_CA_CERTS
    value: /usr/local/share/ca-certificates/ca.crt
  - name: RUNNER_UPDATE_CA_CERTS
    value: "1"
serviceAccount:
  create: true
  annotations: {}
  name: ""
podAnnotations: {}
podLabels: {}
podSecurityContext: {}
securityContext: {}
resources: {}
nodeSelector: {}
tolerations: []
affinity: {}
topologySpreadConstraints: []
volumes:
- name: github-server-tls-cert
  configMap:
    name: umbrella.crt
    items:
      - key: ca.crt
        path: ca.crt
volumeMounts:
- name: github-server-tls-cert
  mountPath: /usr/local/share/ca-certificates/ca.crt
  subPath: ca.crt
priorityClassName: ""
flags:
  logLevel: "debug"
  logFormat: "text"
  updateStrategy: "immediate"
```

The parameters we modify for the controller to work in our EKS environment are as shown above:

- `ECR_IMAGE_URL`: URL to the ECR project where the github controller image was uploaded.
- `CHART_VERSION`: Current chart and image version being used. (currently, 0.9.3)
- `HTTP_PROXY`: Given http proxy to use by the controller (for example: [http://proxy.sig.umbrella.com:80/](http://proxy.sig.umbrella.com:80/)")
- `HTTPS_PROXY`: Given https proxy to use by the controller (for example: [http://proxy.sig.umbrella.com:443/](http://proxy.sig.umbrella.com:443/)")
- `NO_PROXY`: Given no proxy to use by the controller (for example: 172.20.0.1,169.254.169.254,169.254.170.2,.cluster.local.,.cluster.local,.svc,.eks.amazonaws.com")

Other values not set as variables are the ones related to the injection of certificates.

The certificate to inject is the one required to use a secure connection to the proxy, in this case we need to create the certificate file and upload it
as explained in the installation because the controller image is not maintained by us and we can't recreate it with our needed certificates.

For this, the chart allows to pass on a certificate and inject it into the pod as needed.

Next we will cover the optional parameters to include depending on your iluster. For now, we only cover the `nodeSelector` for deployng runners in a shared cluster where apps and runners coexist:

```yaml
nodeSelector:
  <NODEGROUP_LABEL_KEY>: <NODEGROUP_LABEL_VALUE>
```

Here we can modify:

- `NODEGROUP_LABEL_KEY`: this is the key for the label to use. We use `work_type` for this.
- `NODEGROUP_LABEL_VALUE`: this is the value of the previous key to define which node group to use. We use `Gluon-app` as we want the controller to be outside of the ephemeral runners as the controller of the scale sets.

##### Original values.yaml

These values file and their description are available in the original documentation. Please refer to it for any parameter we are not using: [Original GitHub values.yaml file](https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set-controller/values.yaml)

### Scaler Set - Values

[Configured Values for Gluon controller](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/inventory/gha-runner-scale-set/values.yaml)

```yaml
githubConfigUrl: "https://github.com/<GITHUB_ORGANIZATION_NAME>"
githubConfigSecret: <CREDENTIALS_SECERT_NAME>
proxy:
  http:
    url: <HTTP_PROXY>
  https:
    url: <HTTPS_PROXY>
  noProxy:
    - <NO_PROXY_1>
    - <NO_PROXY_2>
    - ...
    - <NO_PROXY_N>
maxRunners: <MAX_RUNNERS>
minRunners: <MIN_RUNNERS>
runnerScaleSetName: <RUNNER_SCALE_SET_NAME>
githubServerTLS:
  certificateFrom:
    configMapKeyRef:
      name: <CA_CONFIGMAP_NAME>
      key: <CA_CONFIGMAP_KEY>
  runnerMountPath: /usr/local/share/ca-certificates/
listenerTemplate:
  spec:
    containers:
    - name: listener
      securityContext:
        runAsUser: 1000
      volumeMounts:
        - name: github-server-tls-cert
          mountPath: /usr/local/share/ca-certificates/<CA_CONFIGMAP_KEY>
          subPath: <CA_CONFIGMAP_KEY>
    volumes:
    - name: github-server-tls-cert
      configMap:
        name: <CA_CONFIGMAP_NAME>
        items:
          - key: <CA_CONFIGMAP_KEY>
            path: <CA_CONFIGMAP_KEY>
template:
  spec:
    containers:
      - name: runner
        image: <ECR_RUNNER_IMAGE>
        imagePullPolicy: IfNotPresent
        env:
          - name: RUNNER_HOME
            value: "/home/runner"
        command: ["/runner/run.sh"]
        securityContext:
          runAsUser: <RUNNER_USER_ID>
```

The parameters we modify for the scale set to work in our EKS environment are as shown above:

- `GITHUB_ORGANIZATION_NAME`: Name of the organization as shown in the organization url (ie: santander-group-gluon-test,
    given the org url [https://github.com/santander-group-gluon-test](https://github.com/santander-group-gluon-test))
- `CREDENTIALS_SECERT_NAME`: Name of the secret created with the GitHub App credentials in the installation process. (ie: pre-defined-secret)
- `HTTP_PROXY`: Given http proxy to use by the scale set and the runners it deploys (ie: [http://proxy.sig.umbrella.com:80/](http://proxy.sig.umbrella.com:80/)")
- `HTTPS_PROXY`: Given https proxy to use by the  scale set and the runners it deploys (ie: [http://proxy.sig.umbrella.com:443/](http://proxy.sig.umbrella.com:443/)")
- `MAX_RUNNERS`: Maximum number of runners deployed. (ie: 5)
- `MIN_RUNNERS`: Minimum number of runners available when idle. It can be 0. (ie: 1)
- `RUNNER_SCALE_SET_NAME`: Name of the runners to deploy, works as the **label** of the runner scale set. (ie: dev-m-aws). It is important
    to note that github forces the scale sets to use a single label and it is not possible to have multiple. This runner name if not defined will be the name of the chart installed.
- `CA_CONFIGMAP_NAME`: name of the configmap created for this purpose on the installation instructions. (ie: umbrella.crt)
- `CA_CONFIGMAP_KEY`: name of the key assigned to the content of the configmap with the certificate. (ie: ca.crt)
- `ECR_RUNNER_IMAGE`: URL of the versioned image in the ECR to deploy as runners. (ie: <DEV_ACCOUNT>.dkr.ecr.eu-west-1.amazonaws.com/<ECR_PROJECT_PATH>:<RUNNER_VERSION>)
- `RUNNER_USER_ID`: ID of the user to run the runner as. In our Gluon runners, we use the id 1000.

These values are the minimum ones we have changed and configured for the scale set to run in our EKS environment.

Next are optional parameters to include depending on your iluster. For now, we only cover the `nodeSelector` for deployng runners in a shared cluster where apps and runners coexist. In the `template` part of the values.yaml we complete it as:

```yaml
template:
  spec:
    containers:
      - name: runner
        ...
    nodeSelector:
      <NODEGROUP_LABEL_KEY>: <NODEGROUP_LABEL_VALUE>
```

Here we can modify:

- `NODEGROUP_LABEL_KEY`: this is the key for the label to use. We use `work_type` for this.
- `NODEGROUP_LABEL_VALUE`: this is the value of the previous key to define which node group to use. We use `Gluon-ephemeral`.

Any other values we don't use can be checked in the original values.yaml template and official documentation

To disable the caches, delete the code block of the runners that are going to be deployed.

```yaml
        volumeMounts:
        - name: maven-volume
          mountPath: /home/runner/.m2/repository
        - name: npm-volume
          mountPath: /home/runner/.npm/_cacache
    volumes:
    - name: maven-volume
      persistentVolumeClaim:
        claimName: mvn-cache
    - name: npm-volume
      persistentVolumeClaim:
        claimName: npm-cache
```

##### Original values.yaml

These values file and their description are available in the original documentation. Please refer to it for any parameter we are not using: [Original GitHub values.yaml file](https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set/values.yaml)

<div class="cards row-3" markdown>

- #### AWS Installation

    ---
    Install using AWS infrastructure

    [:computer: AWS Installation](./installation.md/)

- #### AWS ephemeral runners administration and maintenance

    ---
    AWS ephemeral runners administration and maintenance

    [:question: Administration and Maintenance](./administration-and-maintenance.md/)

</div>
