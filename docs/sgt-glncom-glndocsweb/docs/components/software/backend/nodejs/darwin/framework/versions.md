---
hide:
  - toc
---

# Darwin NodeJs Framework versions

Darwin NodeJs Framework is following the next semantic versioning:

- A normal release version takes the form `X.Y.Z`, where X, Y and Z are non-negative integers. X is the major version, Y is the minor version and Z is the patch version.

- We publish a "**major version**" when it may contain backward **incompatible** changes and/or **minor/major NodeJs** dependencies upgrades. It may also include "minor or patch level" changes.
- We publish a "**minor version**" when it contains backward compatible new features and minor **not NodeJs** dependencies upgrades. It may also include "patch level" changes.
- We publish a "**patch version**" when it contains only backward compatible bug fixes and patch dependencies upgrades.
- Only the last minor version of each "live" major version is supported.

This table contains the most important information about Darwin FW releases as NodeJs:

| Darwin NodeJs FW                                                                          | Gluon version | Fastify | Nodejs version supported | First Release Date | Darwin End of Support | NodeJs End of Support |            Last Patch version             |
|:------------------------------------------------------------------------------------------:|:---------------:|:------------------:|:----------------:|--------------|:----------------------:|:------------------:|:---------------------:|
| **Version v4.*** [(Doc)](index.md) <p style="color:green">CURRENT - GA</p>   | v8.*        |    v5.*       |          v20, v22           |  April 2024        |       April 2025       |         April 2026         |       **4.3.0** <p>(September 2025)</p>       |

!!! note "Nodejs End of Support"

    The column "Nodejs End of Support" is included here to warn that when the Nodejs version support of a
    Darwin version has finished, this Darwin version can continue publishing patches about Darwin bugs or vulnerabilities
    but not about Nodejs vulnerabilities.
