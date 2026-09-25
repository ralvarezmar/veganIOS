---
title: Enable tags and timeout configuration in AWS, create kid property in S3, and change API parameter from authorization to Authorization
categories:
  - APIs
date:
  created: 2025-07-03
tags:
  - Feature
---
 
![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

1. Custom tags can now be configured for API deployment in AWS.
2. Timeout can now be configured for the integration of API operations in AWS.
3. The `kid` property obtained from OAM is now also created in the file deployed to S3 if configured during API deployment in AWS.
4. The API authorization parameter is changed from `authorization` to `Authorization`.

### Why Is This Important?

1. Allows greater flexibility when configuring custom tags for API deployment in AWS, facilitating resource identification and categorization.
2. Configuring the timeout for API operation integrations improves adjustability and prevents potential timeout issues in high-latency environments.
3. Creating the `kid` property in the file deployed to S3 ensures that the necessary information is available for future integrations or queries.
4. Changing the authorization parameter from `authorization` to `Authorization` standardizes naming and avoids confusion in API configuration, aligning with the standard defined in RFC 7235 for HTTP headers related to authentication.
