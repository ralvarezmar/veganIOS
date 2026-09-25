---
hide:
  - toc
---

# Darwin Python Framework versions

Darwin Python Framework is following the next semantic versioning:

- A normal release version takes the form `X.Y.Z`, where X, Y and Z are non-negative integers. X is the major version, Y is the minor version and Z is the patch version.

- We publish a "**major version**" when it may contain backward **incompatible** changes and/or **minor/major Python** dependencies upgrades. It may also include "minor or patch level" changes.
- We publish a "**minor version**" when it contains backward compatible new features and minor **not Python** dependencies upgrades. It may also include "patch level" changes.
- We publish a "**patch version**" when it contains only backward compatible bug fixes and patch dependencies upgrades.
- Only the last minor version of each "live" major version is supported.

This table contains the most important information about Darwin FW releases as Python:

| Darwin Python FW                                                                          | Gluon version | FastAPI | Python version supported | First Release Date | Darwin End of Support | Python End of Support |            Last Patch version             |
|:------------------------------------------------------------------------------------------:|:---------------:|:------------------:|:----------------:|--------------|:----------------------:|:------------------:|:---------------------:|
| **Version v4.*** [(Doc)](index.md) <p style="color:green">CURRENT - GA</p>   | v7.*        |    v0.*         |          v3.11           |  May 2024        |       December 2027       |         April 2025         |       **4.1.5** <p>(April 2025)</p>       |

!!! note "Python End of Support"

    The column "Python End of Support" is included here to warn that when the Python version support of a
    Darwin version has finished, this Darwin version can continue publishing patches about Darwin bugs or vulnerabilities
    but not about Python vulnerabilities.
