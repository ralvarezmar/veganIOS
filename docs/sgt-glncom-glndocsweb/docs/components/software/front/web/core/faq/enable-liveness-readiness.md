# How to enable `livenessProbe` and `readinessProbe` in a Kubernetes container for a front-end application

1.**Enable the properties**

Open the container configuration file `.gluon/cd/values.yaml`:

```yaml
livenessProbe:
  enabled: true
  initialDelaySeconds: 60
  timeoutSeconds: 1
  periodSeconds: 30
  successThreshold: 1
  failureThreshold: 3

readinessProbe:
  enabled: true
  initialDelaySeconds: 10
  timeoutSeconds: 1
  periodSeconds: 30
  successThreshold: 1
  failureThreshold: 3
```

2.**Check HealthCheck endpoint exposure**

In the Nginx configuration, the `/health` endpoint should be exposed, it is possible that this endpoint is already exposed but with another route. In this case, the Nginx configuration should be modified to expose the `/health` endpoint.

Open the Nginx configuration file `nginx/default.conf`:

```nginx
  location /health {
    stub_status on;
    access_log off;
    allow 127.0.0.1;
    allow 10.0.0.0/8;
    deny all;
  }
```
