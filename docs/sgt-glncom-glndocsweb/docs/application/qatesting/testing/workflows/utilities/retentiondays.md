---
title: Testing files generated Retention Days Policy
hide:
  - toc
---

## **File retention days policy in testing workflows**

When running tests through workflows we are creating some files, reports, results, summary, big reports with screenshots and so on.
To keep them in the workflow execution, to not allow all files be kept in GitHub.com with the default retention day policy that is 90 days, we stablish a policy dynamically for every file generated depending of its size.

The policy is as follows:

|**Size**|**Retention Days**|**Use Case**|
|---  |---  |---  |
|Very Small Files (≤ 1 MB)|30 days|very small logs|
|Small Files (≤ 10 MB)|30 days|Small logs, configuration files, scripts|
|Medium Files (> 10 MB and ≤ 100 MB)|14 days|Build artifacts, medium-sized datasets|
|Large Files (> 100 MB and ≤ 1 GB)|7 days|Large datasets, binary files, container images|
|Very Large Files (> 1 GB)|3 days|Extensive datasets, backup files, comprehensive logs|
