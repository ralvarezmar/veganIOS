---
title: Enable Draft Uploads in API Connect for APIs and API Products through OAM Configuration
categories:
  - APIs
date:
  created: 2025-07-03
tags:
  - Feature
---
 
![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

The default behavior of Gluon when deploying APIs and API Products in IBM API Connect was modified to avoid uploading Drafts, in order to prevent generating unnecessary entries in the API Managers.
The API assembly is uploaded to Nexus, and the API Product assembly is displayed as part of the deployment logs, making its content available.

To allow Draft uploads if an application finds it useful, the optional property 'ibm-drafts' has been enabled in the OAM configuration for APIs and Products. If set to true, the Draft will be uploaded as part of the deployment.

### Why Is This Important?

For some applications, having the Draft available in the API Manager is useful for troubleshooting.
However, no manual actions should be taken to modify APIs and API Products deployed by Gluon, as this may cause errors in subsequent version deployments.f i
