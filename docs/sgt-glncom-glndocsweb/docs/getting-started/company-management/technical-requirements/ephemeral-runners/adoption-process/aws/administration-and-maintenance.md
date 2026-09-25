---
Title: AWS Ephemeral Runners Administration and Maintenance
---

Administer and maintain your scale sets in your environment.

The github.com environments are used for account management, aws eks.

## Administration

### Preparing Namespace

For this task we can modify and/or run the workflow action ```prepare_namespace.yml``` found in this [repository path](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/.github/workflows/prepareNamespace.yaml).

This workflow will:

- Create the namespace for the org.
- Create the secret.
- Create PVC to store cache for maven and npm cache.
- Create the configmap of the umbrella certificate.

### Deploying scale sets controller

To deliver this task we can make use of the file ```cd-controller.yaml``` found in this [repository path](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/.github/workflows/cd-controller.yaml).

For the deployment we have 2 main values:

- The values stored in inventory/gha-runner-scale-set-controller/default: these values define the common values for each controller.
- The values stored in inventory/gha-runner-scale-set-controller/environment: these values define the common values for the environment.

### Deploying scale sets

#### One by one deployment

To deliver this task we can make use of the file ```cd.yaml``` found in this [repository path](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/.github/workflows/cd.yaml).

For the deployment we have 3 main values:

- The values stored in inventory/gha-runner-scale-set/default: these values define the common values for each runner.
- The values stored in inventory/gha-runner-scale-set/size: these values define the common values for the sizes.
- The values stored in inventory/gha-runner-scale-set/organizations/organisation_name: these values overwrite the default and size values if any organisation needs a change like resources or variables.

To run this workflow you need the following variables:

- Organization to deploy.
- Environment: pro, pre or dev.
- size: yaml of the runner to deploy without extension.
- Runner to run the workflow

#### Multideployment

If what we want is to serial deploy on many organizations, we can make use of ```multideployment.yaml``` found in this [repository path](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/tree/main/.github/workflows).

Prior of launching it, we must create a file inside [multideploy_lists](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/tree/main/multideploy_lists), i.e. ```multideploy_somename.txt```

Enter all the organizations that we want to deliver deploy, one per line.

Now we run ```multideploy``` and follow the dispatch. On ```yaml with the list for deploy on organizations``` enter the newly created file ```multideploy_somename.txt```. After pressing ```Run workflow``` button, the Action workflow will batch
all the deployments indicated.

To run this workflow you need the following variables:

- Environment: pro, pre or dev.
- yaml: yaml of the runner to deploy without extension.
- size: yaml of the runner to deploy without extension.
- Runner to run the workflow

### Uninstalling scale sets

#### One by one uninstall

For this purpose we can make use of ```uninstall.yaml``` found in this [repository path](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/tree/main/.github/workflows)

To run this workflow you need the following variables:

- Organization to deploy.
- Environment: pro, pre or dev.
- size: yaml of the runner to deploy without extension.
- Runner to run the workflow

### List all helm installations

To list all helm installations to check the deployed runner scale sets in a namespace we use:

```bash
helm ls -n <namespace>

NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
arc             controller-ns   8               2044-15-13 14:30:49.2533244 +0200 CEST  deployed        gha-runner-scale-set-controller-0.9.3   0.9.3
arc-scale-set   controller-ns   3               2044-15-13 14:30:49.2533244 +0200 CEST  deployed        gha-runner-scale-set-0.9.3              0.9.3
```

This example shows that in the same namespace there are different helm charts. This might need to be run in each namespace with runner installations or where the controller is installed.

### Uninstall helm charts

To remove an installation

```bash
helm ls -n <namespace>
helm uninstall <chart-name> -n <namespace>
```

#### Upgrade chart

To upgrade a chart we use the same command used to initially install it as it is an upgrade command that installs the chart if it is not already installed.

```sh
helm upgrade --install arc-controller --namespace arc-controller-namespace -f ./inventory/gha-runner-scale-set-controller/values.yaml oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller --version 0.9.3
```

## Maintenance

### Monitoring ARC pods status

Within the components of the ARC deployment, to check the general status of the runners we need to check if they are up and running.

#### Check the controller and listeners status

```sh
kubectl -n controller-namespace get pods

NAME                                     READY   STATUS      RESTARTS   AGE
controller-name-12345abcde-12345         1/1     Running     0          4d4h
runner-name-1234abcd-listener            1/1     Running     0          4d3h
```

And the same for any organization namespace:

```sh
kubectl -n organization-namespace get pods

NAME                                     READY   STATUS      RESTARTS   AGE
runner-name-12345-runner-abcde           1/1     Running     0          5m16s
```

### Check the CustomResourceDefinition of the ephemeral runners

We also need to check the CRD instances that contain the runner pods. We can check the runners an EphemeralRunners and EphemeralRunnersSet contain:

```sh
kubectl -n arc-dev get ephemeralrunners

NAME                           GITHUB CONFIG URL                          RUNNERID   STATUS    JOBREPOSITORY   JOBWORKFLOWREF   WORKFLOWRUNID   JOBDISPLAYNAME   MESSAGE   AGE
runner-name-12345-runner-abcde https://github.com/santander-group-org     123456     Running                                                                               58s
```

Or the set:

```sh
kubectl -n arc-dev get ephemeralrunnerset

NAME              DESIREDREPLICAS   CURRENTREPLICAS   PENDING RUNNERS   RUNNING RUNNERS   FINISHED RUNNERS   DELETING RUNNERS
runner-name-12345 1                 1                 0                 1
```

### Troubleshooting

The first step to investigate issues when deploying is to know where to look. There are multiple components involved when deploying runners and the error might be in one of them or in the steps in between them.

For the purpose of helping with any errors, this is where to get the information to attach to any ticket or issue.

#### Get any pod logs

We always need to check all three components for log errors:

1. Controller
2. Listener
3. Runner

```sh

kubectl -n target-namespace logs target-pod-name

```

#### Get events from a target namespace

```sh

kubectl -n target-namespace get events --sort-by='.lastTimestamp'
```

#### Add sleep to start command to debug

One possible error is that the listener is up, the EphemeralRunnerSet is up and trying to create runners, but the runners fail and so it stops recreating them.

In this case we can change from the script that creates a runner instance in the pod to a sleep We need to change the `command` in the values yaml to:

```yaml

command: ["sleep 3600"]
```

With this we will be able to connect to the runner pod and get some more traces of a possible error.

### Connect to a runner

To connect to a runner we need to know the namespace and name of the runner. With that information we will run the kubectl command:

```sh

kubectl -n namespace-name exec -it runner-pod-name -- bash
```

### Known Troubleshooting Issues

These are known issues we have faced during the deployments but all of them are fixed if using the documentantion.

1. Certificate errors on the controller and listener. This is due to the need to inject the cert in the pods as explained in the installation.
2. The listener is up but there are no runners. There can be multiple reasons, follow the previous steps to add a sleep and connect to the runner to debug.
3. ECR image pull error. Review the image, version and ECR account are correct.
4. Upgrading a scale set in a namespace to use a new secret and point to a different organization doesn't work. You either install a new scale set or uninstall and reinstall an existing one.

### Other sections in AWS adoption process

<div class="cards row-2" markdown>

- #### AWS Installation

    ---
    AWS ephemeral runners installation

    [:computer: AWS Installation](./installation.md/)

- #### AWS Customization and Scaling

    ---
    Customize and Scale your ephemeral runners install

    [:rocket: Customization and Scaling](./customization-and-scaling.md/)

</div>
