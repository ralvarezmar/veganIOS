---
hide:
  - toc
---
[gln-msrv-docs-3-2]: <https://gluon.dev.corp/microservices/docs/darwin-spring-boot/site/3.2.9-RELEASE/index.html>
[gln-msrv-docs-3-1]: <https://gluon.dev.corp/microservices/docs/darwin-spring-boot/site/3.1.5-RELEASE/index.html>
[gln-msrv-docs-3-0]: <https://gluon.dev.corp/microservices/docs/darwin-spring-boot/site/3.0.6-RELEASE/index.html>
[gln-msrv-docs-2-11]: <https://gluon.dev.corp/microservices/docs/darwin-spring-boot/site/2.11.4-RELEASE/index.html>
[gln-msrv-docs-2-10]: <https://gluon.dev.corp/microservices/docs/darwin-spring-boot/site/2.10.5-RELEASE/index.html>
[gln-msrv-docs-2-9]: <https://gluon.dev.corp/microservices/docs/darwin-spring-boot/site/2.9.2-RELEASE/index.html>

# Darwin Spring Boot Framework versions

Darwin Spring Boot Framework is following the next semantic versioning:

- A normal release version takes the form `X.Y.Z`, where X, Y and Z are non-negative integers. X is the major version, Y is the minor version and Z is the patch version.

!!! important "Release version naming"

    Prior to 5.0.0 version, release versions included a *-RELEASE* suffix.

- We publish a "**major version**" when it may contain backward **incompatible** changes and/or **minor/major Spring Boot** dependencies upgrades. It may also include "minor or patch level" changes.
- We publish a "**minor version**" when it contains backward compatible new features and minor **not Spring Boot** dependencies upgrades. It may also include "patch level" changes.
- We publish a "**patch version**" when it contains only backward compatible bug fixes and patch dependencies upgrades.
- Only the last minor version of each "live" major version is supported[^1].

This table contains the most important information about Darwin SB FW releases as Spring Boot, Spring Cloud and Java version supported, release dates or the Gluon version that start using that version:

| Darwin Spring Boot FW                                                                          | Gluon version | Spring Boot parent | Spring Framework | Spring Cloud | Java version supported | First Release Date | Darwin End of Support | Spring Boot End of Support |            Last Patch version             |
|------------------------------------------------------------------------------------------------|---------------|:------------------:|:----------------:|--------------|:----------------------:|:------------------:|:---------------------:|:--------------------------:|:-----------------------------------------:|
| **Darwin Spring Boot 6.3.x** [(Doc)](current/index.md) <p style="color:green">CURRENT - GA</p> | v9.1.0        |       3.5.7        |      6.2.12      | 2025.0.0     |           17           |   September 2025   |       July 2026       |         2026-06-01         |     **6.3.4** <p>(November 2025)</p>     |
| **Darwin Spring Boot 6.2.x** <p style="color:red">DEPRECATED</p>                               | v7.1.0        |       3.4.7        |      6.2.8       | 2024.0.1     |           17           |      May 2025      |       July 2026       |         2025-11-23         |       **6.2.1** <p>(June 2025)</p>        |
| **Darwin Spring Boot 6.1.x** <p style="color:red">DEPRECATED</p>                               | v7.1.0        |       3.4.6        |      6.2.7       | 2024.0.1     |           17           |     April 2025     |       July 2026       |         2025-11-23         |        **6.1.2** <p>(May 2025)</p>        |
| **Darwin Spring Boot 6.0.x** <p style="color:red">DEPRECATED</p>                               | v6.4.0        |       3.4.4        |      6.2.5       | 2024.0.0     |           17           |   February 2025    |       July 2026       |         2025-11-23         |       **6.0.3** <p>(March 2025)</p>       |
| **Darwin Spring Boot 5.8.x** [(Doc)](darwin-5-x/index.md) <p style="color:orange">GA</p>       | N/A           |       3.3.11       |      6.1.19      | 2023.0.5     |           17           |     April 2025     |       July 2025       |         2025-05-23         |       **5.8.1** <p>(April 2025)</p>       |
| **Darwin Spring Boot 5.7.x** <p style="color:red">DEPRECATED</p>                               | v6.3.0        |       3.3.10       |      6.1.18      | 2023.0.5     |           17           |    January 2025    |       July 2025       |         2025-05-23         |       **5.7.4** <p>(March 2025)</p>       |
| **Darwin Spring Boot 5.6.x** <p style="color:red">DEPRECATED</p>                               | v6.2.0        |       3.3.7        |      6.1.16      | 2023.0.4     |           17           |   December 2024    |       July 2025       |         2025-05-23         |     **5.6.0** <p>(December 2024)</p>      |
| **Darwin Spring Boot 5.5.x** <p style="color:red">DEPRECATED</p>                               | v6.1.0        |       3.3.6        |      6.1.15      | 2023.0.3     |           17           |   November 2024    |       July 2025       |         2025-05-23         |     **5.5.0** <p>(November 2024)</p>      |
| **Darwin Spring Boot 5.4.x** <p style="color:red">DEPRECATED</p>                               | v5.8.0        |       3.2.11       |      6.1.14      | 2023.0.3     |           17           |   November 2024    |       July 2025       |         2024-11-23         |     **5.4.0** <p>(November 2024)</p>      |
| **Darwin Spring Boot 5.3.x** <p style="color:red">DEPRECATED</p>                               | v5.2.0        |       3.2.10       |      6.1.14      | 2023.0.3     |           17           |   September 2024   |       July 2025       |         2024-11-23         |      **5.3.2** <p>(October 2024)</p>      |
| **Darwin Spring Boot 5.2.x** <p style="color:red">DEPRECATED</p>                               | v5.1.0        |       3.2.8        |      6.1.12      | 2023.0.2     |           17           |    August 2024     |       July 2025       |         2024-11-23         |      **5.2.1** <p>(August 2024)</p>       |
| **Darwin Spring Boot 5.1.x** <p style="color:red">DEPRECATED</p>                               | v5.0.0        |       3.2.8        |      6.1.11      | 2023.0.2     |           17           |     July 2024      |       July 2025       |         2024-11-23         |       **5.1.0** <p>(July 2024)</p>        |
| **Darwin Spring Boot 5.0.x** <p style="color:red">DEPRECATED</p>                               | v3.4.0        |       3.2.7        |      6.1.10      | 2023.0.2     |           17           |     April 2024     |       July 2025       |         2024-11-23         |       **5.0.2** <p>(July 2024)</p>        |
| **Darwin Spring Boot 4.3.x** [(Doc)](darwin-4-x/index.md) <p style="color:red">DEPRECATED</p>  | v3.2.0        |       3.1.12       |      6.0.21      | 2022.0.5     |           17           |   February 2024    |     January 2025      |         2024-05-18         |    **4.3.3-RELEASE** <p>(May 2024)</p>    |
| **Darwin Spring Boot 4.2.x** <p style="color:red">DEPRECATED</p>                               | v3.0.0        |       3.1.8        |      6.0.16      | 2022.0.4     |           17           |    January 2024    |     January 2025      |         2024-05-18         |  **4.2.0-RELEASE** <p>(January 2024)</p>  |
| **Darwin Spring Boot 4.1.x** <p style="color:red">DEPRECATED</p>                               | v2.3.0        |       3.1.6        |      6.0.14      | 2022.0.4     |           17           |   November 2023    |     January 2024      |         2024-05-18         | **4.1.1-RELEASE** <p>(December 2023)</p>  |
| **Darwin Spring Boot 4.0.x** <p style="color:red">DEPRECATED</p>                               | v2.0.1        |       3.1.3        |      6.0.11      | 2022.0.4     |           17           |    August 2023     |     November 2023     |         2024-05-18         | **4.0.2-RELEASE** <p>(November 2023)</p>  |
| **Darwin Spring Boot 3.2.x** [(Doc)][gln-msrv-docs-3-2] <p style="color:red">DEPRECATED</p>    | v2.0.1        |       2.7.18       |      5.3.31      | 2021.0.8     |         11, 17         |    January 2023    |       July 2024       |         2023-11-24         | **3.2.9-RELEASE** <p>(November 2023)</p>  |
| **Darwin Spring Boot 3.1.x** [(Doc)][gln-msrv-docs-3-1] <p style="color:red">DEPRECATED</p>    | N/A           |       2.6.14       |      5.3.24      | 2021.0.8     |         11, 17         |     July 2022      |     January 2024      |         2023-11-24         |  **3.1.5-RELEASE** <p>(January 2023)</p>  |
| **Darwin Spring Boot 3.0.x** [(Doc)][gln-msrv-docs-3-0] <p style="color:red">DEPRECATED</p>    | N/A           |       2.6.14       |      5.3.24      | 2021.0.8     |           11           |    January 2022    |       July 2023       |         2023-11-24         | **3.0.6-RELEASE** <p>(November 2022)</p>  |
| **Darwin Spring Boot 2.11.x** [(Doc)][gln-msrv-docs-2-11] <p style="color:red">DEPRECATED</p>  | N/A           |   2.3.12.RELEASE   |  5.2.15.RELEASE  | HOXTON.SR11  |         8, 11          |     July 2021      |       July 2022       |         2021-05-20         | **2.11.4-RELEASE** <p>(February 2022)</p> |
| **Darwin Spring Boot 2.10.x** [(Doc)][gln-msrv-docs-2-10] <p style="color:red">DEPRECATED</p>  | N/A           |   2.3.9.RELEASE    |  5.2.13.RELEASE  | HOXTON.SR10  |         8, 11          |     March 2021     |       July 2022       |         2021-05-20         |   **2.10.5-RELEASE** <p>(July 2021)</p>   |
| **Darwin Spring Boot 2.9.x** [(Doc)][gln-msrv-docs-2-9] <p style="color:red">DEPRECATED</p>    | N/A           |   2.3.7.RELEASE    |  5.2.12.RELEASE  | HOXTON.SR9   |           8            |    January 2021    |       July 2022       |         2021-05-20         |  **2.9.2-RELEASE** <p>(August 2021)</p>   |

!!! note "Spring Boot End of Support"

    The column "Spring Boot End of Support" is included here to warn that when the Spring Boot version support of a
    Darwin version has finished, this Darwin version can continue publishing patches about Darwin bugs or vulnerabilities
    but not about Spring Boot vulnerabilities.

[^1]: This policy is applied starting at Darwin 4.
