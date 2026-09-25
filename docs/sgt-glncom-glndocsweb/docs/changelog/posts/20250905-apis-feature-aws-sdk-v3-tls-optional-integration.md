---
title: AWS API Gateway Improvements and SDK Migration
categories:
  - APIs
date:
  created: 2025-09-05
tags:
  - Feature
---
 
![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

This update includes internal improvements to AWS API Gateway integration with no breaking changes:

- **AWS SDK migration from v2 to v3:**  
  Internal upgrade that improves performance and reduces bundle size. No action required from users.

- **tlsSkipVerification (Optional configuration):**  
  New optional parameter that can be set to `true` to disable SSL/TLS certificate verification in AWS. Default is `false` (verification enabled).

- **Enhanced Lambda trigger generation:**  
  Improved automatic trigger creation for Lambda functions when API Gateway updates are executed. No user action required.

### Why Is This Important?

These improvements enhance the platform with minimal user impact:

- **Better performance:** Internal SDK upgrade provides faster execution and smaller memory footprint.
- **Optional TLS flexibility:** Users can now optionally disable certificate verification for development scenarios.
- **Automated Lambda integration:** Improved reliability in serverless function triggering.
