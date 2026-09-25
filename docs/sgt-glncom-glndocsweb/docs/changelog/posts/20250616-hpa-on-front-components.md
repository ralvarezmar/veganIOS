---
title: HPA on front web components
categories:
  - Web
date:
  created: 2025-06-16
tags:
  - Feature
---

![Feature](../assets/images/new-feature-blog.png){ width=100%}

We are excited to announce that, starting today, **our users can configure Horizontal Pod Autoscaling (HPA) for frontend web components** deployed on Kubernetes.
This new feature empowers teams to optimize resource usage and ensure high availability for their web applications

### Why is this important?

HPA (Horizontal Pod Autoscaler) is a key feature in Kubernetes environments that **automatically adjusts the number of pod replicas** in response to real-time demand.
By leveraging HPA, your applications can seamlessly scale out during peak usage and scale in when demand drops, ensuring optimal performance and cost efficiency.
This is especially valuable for frontend web components, where user traffic can fluctuate significantly.

### How to Use This Feature?

To enable HPA for your frontend web components, you need to configure the relevant options in your deployment configuration files (values.yaml for Helm charts).
Simply specify the desired metrics (like CPU or memory utilization) and the scaling thresholds.
Once configured, Kubernetes will automatically manage the scaling of your pods based on the defined criteria.

For detailed step-by-step instructions and best practices, please refer to our [official documentation](../../components/software/front/web/core/best-practices/kubernetes/hpa.md).
