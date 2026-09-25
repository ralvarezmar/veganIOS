---
title: Enabled multiple AsyncAPI versions and implemented automatic schema and AsyncAPI validation
categories:
  - Events
date:
  created: 2025-09-11
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png){width=100%}

### What's Changing?

The workflow now dynamically resolves repository names using CP values, adapting to recent Marketplace API changes. Support for AsyncAPI versions `2.5.0`, `2.6.0`, and `3.0.0` has been added, enhancing integration flexibility.
Automated validation has been introduced for both AsyncAPI definitions and schema files (AVRO and JSON), ensuring reliability and standardization.
Additionally, the inclusion of `component_id` in OpenSearch data improves traceability, while the retention period parameter (`retention.ms`) now aligns with Kafka standards by using milliseconds.
Event management has been streamlined with direct repository URL lookup based on `component_id`, and all workflows now reference reusable workflow version v2.0.0 for better consistency and reliability.

### Why Is This Important?

These updates ensure a more robust and adaptable release process by improving workflow consistency, enhancing compatibility with multiple AsyncAPI versions, and automating validation for AsyncAPI and schema files.
The inclusion of `component_id` in OpenSearch data improves traceability, while the alignment of the `retention.ms` parameter with Kafka standards enhances usability.
