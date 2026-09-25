---
title: Image Governance
hide:
  - toc
---

Deployment images will be provided by the gluon platform team.

The images will need to be updated once provided, generally once a month, as they contain the new version of the runner application.

The images of the ephemeral runners are stored in Harbor registry:

- [Core image](https://registry.global.ccc.srvb.can.paas.cloudcenter.corp/harbor/projects/19/repositories/gln-plat-node-github-runner)
- [Android image](https://registry.global.ccc.srvb.can.paas.cloudcenter.corp/harbor/projects/19/repositories/gln-plat-android-github-runner)
- [Core image Aws](https://registry.global.ccc.srvb.can.paas.cloudcenter.corp/harbor/projects/19/repositories/gln-plat-core-aws-gh-runner)
- [Android image Aws](https://registry.global.ccc.srvb.can.paas.cloudcenter.corp/harbor/projects/19/repositories/gln-plat-android-aws-gh-runner)

To integrate new technologies in the runners, you need to open a [Gluon request](../../../support/index.md).

### Software versions disclaimer

:exclamation: **The use of obsolete software in Gluon involve a risk derivated from vulnerabilities on it. The entity using those runners need to have
previously manage that risk, so the use of Gluon just involve a transfer of the risk from previous environment to a new one. It's up to the team to manage a waiver to deal with that.**

### Other sections in Ephemeral runners

<div class="cards row-2" markdown>

- #### Ephemeral Runners Adoption Process

    ---
    Learn about the adoption process and infrastructure supported.

    [:white_check_mark: Learn about the adoption process](./adoption-process/index.md)

- #### Runners Flavours

    ---
    Check out what images we have available to use with ephemeral runners so far.

    [:rocket: Flavours](./flavours.md)

</div>
