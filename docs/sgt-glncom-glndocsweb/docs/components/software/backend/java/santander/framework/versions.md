---
hide:
  - toc
---

# Santander Spring Boot Framework versions

Santander Spring Boot Framework is following the next semantic versioning:

- A normal release version takes the form `X.Y.Z`, where X, Y and Z are non-negative integers. X is the major version, Y is the minor version and Z is the patch version.
- We publish a "**major version**" when it may contain backward **incompatible** changes and/or **minor/major Spring Boot** dependencies upgrades. It may also include "minor or patch level" changes.
- We publish a "**minor version**" when it contains backward compatible new features and minor **not Spring Boot** dependencies upgrades. It may also include "patch level" changes.
- We publish a "**patch version**" when it contains only backward compatible bug fixes and patch dependencies upgrades.
- Only the last minor version of each "live" major version is supported.

This table contains the most important information about Santander SB FW releases as Spring Boot, Spring Cloud and Java version supported, release dates or the Gluon version that start using that version:

| Santander Spring Boot FW                                                                          | Gluon version | Spring Boot parent | Spring Framework | Spring Cloud | Java version supported | First Release Date | Santander Spring Boot End of Support | Spring Boot End of Support |         Last Patch version        |
|---------------------------------------------------------------------------------------------------|---------------|:------------------:|:----------------:|--------------|:----------------------:|:------------------:|:------------------------------------:|:--------------------------:|:---------------------------------:|
| **Santander Spring Boot 1.2.x** [(Doc)](current/index.md) <p style="color:green">CURRENT - GA</p>              | v9.1.0        |       3.5.6        |      6.2.11      | 2025.0.0     |           17           |    August 2025     |              July 2026               |         2026-06-01         | **1.2.1** <p>(Septembre 2025)</p> |
| **Santander Spring Boot 1.1.x** <p style="color:red">DEPRECATED</p>                               | v8.3.0        |       3.5.4        |      6.2.10      | 2025.0.0     |           17           |    August 2025     |              July 2026               |         2026-06-01         | **1.1.0** <p>(August 2025)</p>    |
| **Santander Spring Boot 1.0.x** <p style="color:red">DEPRECATED</p>                               | v8.0.0        |       3.4.7        |      6.2.8       | 2024.0.1     |           17           |     July 2025      |              July 2026               |         2025-11-23         | **1.0.1** <p>(July 2025)</p>      |

!!! note "Spring Boot End of Support"

    The column "Spring Boot End of Support" is included here to warn that when the Spring Boot version support of a
    Santander Spring Boot version has finished,
    this Santander Spring Boot version can continue publishing patches about Santander Spring Boot bugs
    or vulnerabilities but not about Spring Boot vulnerabilities.
