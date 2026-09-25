---
title: Enable x-santander-client-id as apikey header instead of X-IBM-Client-Id in IBM Api Connect
categories:
  - APIs
date:
  created: 2025-08-07
tags:
  - Feature
---
 
![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

The default behavior of IBM API Connect was to force the use of the header X-IBM-Client-Id as apikey security, coupling the api-spec to the technology.

Any other API technology used in Gluon uses the x-santander-client-id and it not relies on a technology coupled header, so it is a necessary step to homogenize all the deployment processes.

To allow x-santander-client-id as apikey in IBM if an application finds it useful, the optional property 'x-santander-client-id' has been enabled in the OAM configuration and in the values-ibm file in the deployment repository.
Values-ibm value will overwrite any value present in OAM. If set to true, x-santander-client-id header will be used instead of X-IBM-Client-Id Draft will be uploaded as part of the deployment.

[Detailed info is available in API deployment doc](../../components/software/api/apideployment/apis.md#specific-configuration-by-technology-ibm-api-connect)

### Why Is This Important?

For some applications, having the Draft available in the API Manager is useful for troubleshooting.
However, no manual actions should be taken to modify APIs and API Products deployed by Gluon, as this may cause errors in subsequent version deployments.f i
