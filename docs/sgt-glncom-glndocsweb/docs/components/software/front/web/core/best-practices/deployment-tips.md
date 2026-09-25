# Deployment Tips for Front-End Components

When deploying front-end components, it is important to choose the right deployment strategy based on your infrastructure and operational needs.
This article provides practical tips for deploying your components either as artifacts to S3 or as immutable images to Kubernetes, and explains how to configure your workflows for optimal efficiency.

## S3 Deployment: Artifact-Based

Deploying to S3 means your front-end application is built as a static artifact (as a ZIP file) and uploaded to an artifact repository.
The deployment process then retrieves this artifact and publishes it to an S3 bucket, making it available as a static website or for further distribution.

**When to use:**  

- You want to serve static assets (HTML, JS, CSS) directly from S3.
- Your application does not require server-side logic or dynamic scaling.

## Kubernetes Deployment: Immutable Image

Deploying to Kubernetes involves building your front-end application into a Docker image. This image is then pushed to a container registry and deployed as an immutable container in your Kubernetes cluster.

**When to use:**  

- You need advanced orchestration, scaling, or integration with backend services.
- Your application benefits from containerization and Kubernetes features.

## Choosing the Deployment Target in OAM

The deployment target is defined in your OAM (Open Application Model) configuration. You must specify the infrastructure type:

- **S3**: For artifact-based deployments.
- **KUBERNETES**: For container-based deployments.

This selection determines how your component will be deployed and which workflows will be triggered.

## CI/CD Workflow Behavior

By default, the CI workflow will build both the artifact (for S3) and the immutable image (for Kubernetes), uploading them to their respective repositories. The CD workflow will then:

- Retrieve the artifact and deploy it to S3.
- Retrieve the image and deploy it to Kubernetes.

This dual approach ensures flexibility, but may not always be necessary.

## Optimizing the Pipeline: Skipping Artifact Upload

If your component is only going to be deployed on Kubernetes, you can skip uploading the artifact to the artifact repository. To do this, set the following in your `./gluon/ci/properties.env` file:

```bash
ARTIFACT_PUBLISH_TARGET=none
```

With this setting, the pipeline will not upload the artifact, making the CI process lighter and faster.

## Summary

- Decide your deployment target (S3 or Kubernetes) in the OAM configuration.
- By default, both artifact and image are built and uploaded in CI.
- CD workflow deploys the artifact to S3 and the image to Kubernetes.
- To skip artifact upload (for Kubernetes-only deployments), set `ARTIFACT_PUBLISH_TARGET=none` in `./gluon/ci/properties.env`.

Following these tips will help you streamline your deployment process and ensure your front-end components are delivered efficiently and reliably.
