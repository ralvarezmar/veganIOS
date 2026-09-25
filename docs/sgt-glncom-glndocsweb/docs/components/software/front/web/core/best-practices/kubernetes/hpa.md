# HPA (Horizontal Pod Autoscaler)

## Purpose

HPA automatically scales the number of pod replicas based on CPU utilization or other select metrics.

## Best Practices

  - Use HPA to automatically scale your application based on demand.
  - Set appropriate CPU thresholds to trigger scaling events.
  - Note that this only make sens y preproduction and productin environments.
  - If you are using the Gluon Front Helm Chart, used by Darwin or React component templates, HPA can be configured in `autoscaling.hpa` property in `values.yaml` file.
  Be sure to configure correct values for certification, preproduction and productions environments in the specific `values-{environment}.yaml` file.
  Here is an example of how to configure on values.yaml file:

    ```yaml
    autoscaling:
      hpa:
        enabled: true
        minReplicas: 3
        maxReplicas: 5
        targetCPU: 80
    ```
