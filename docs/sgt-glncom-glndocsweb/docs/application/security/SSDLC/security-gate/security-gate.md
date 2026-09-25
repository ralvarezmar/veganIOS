# Security Gate

At the end of the scan, the Security Gate evaluates the results to decide whether the deployment of the software component should be allowed or blocked, depending on the use case.

## SAST/DAST

For SAST and DAST scans, the following criteria are applied:

- **Critical or High Vulnerabilities**: If the component has Critical or High vulnerabilities, it will be blocked.

  ![critical-high-vulnerabilities](../../../../components/configuration/security/images/critical-high-vulnerabilities-sast-dast.png)

- **Medium or Low Vulnerabilities**: If the component only has Medium or Low vulnerabilities, the deployment is not blocked.

  ![medium-low-vulnerabilities](../../../../components/configuration/security/images/medium-low-vulnerabilities-sast-dast.png)

- **No Vulnerabilities**: If no vulnerabilities are detected, the deployment is not blocked.

  ![no-vulnerabilities](../../../../components/configuration/security/images/no-vulnerabilities.png)

## SCA

In the context of SCA, the security gate takes into account the following factors:

- **Critical or High Vulnerabilities**: If the component has Critical or High vulnerabilities, the decision depends on whether fixes are available for the vulnerabilities.

    - **Fix Available**: If any vulnerability has a fix, the pipeline will block execution, and the issue must be resolved before proceeding.

    ![fix](../../../../components/configuration/security/images/critical-high-vulnerabilities-fix-sca.png)

    - **No Fix Available**: If none of the vulnerabilities have a fix, the pipeline will not block, allowing progress until solutions become available.

    ![no-fix](../../../../components/configuration/security/images/critical-high-vulnerabilities-sin-fix.png)

- **Medium or Low Vulnerabilities**: If the component only has Medium or Low vulnerabilities, the deployment is not blocked.

  ![medium-low-vulnerabilities-sca](../../../../components/configuration/security/images/medium-low-vulnerabilities-sca.png)

- **No Vulnerabilities**: If no vulnerabilities are detected, the deployment is not blocked.

  ![no-vulnerabilities-sca](../../../../components/configuration/security/images/no-vulnerabilities-sca.png)
  
- **Brownfield**: If it is a Brownfield component and meets the exception conditions, a warning is generated instead of blocking the deployment. Check [Brownfield](../brownfield/brownfield.md) documentation.

  ![no-vulnerabilities-sca](../../../../components/configuration/security/images/vulnerabilities-brownfield-sca.png)

> **⚠ Warning**
>When a scan detects at least one vulnerability without a fix, a warning will be displayed in the log indicating its detection and possible future blocking once fix is published.
