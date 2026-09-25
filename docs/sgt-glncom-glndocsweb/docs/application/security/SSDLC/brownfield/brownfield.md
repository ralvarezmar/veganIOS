# Vulnerability Assessment and Brownfield Exceptions

## Overview

This system evaluates security vulnerabilities detected in the source code and applies specific rules to determine whether the component should be blocked, generate warnings, or be exempted under certain conditions.
(such as in the case of **Brownfield** components).

The main goal is to ensure that components comply with established security standards while allowing some flexibility for legacy or transitioning components.

---

## What Does This System Do?

1. **Vulnerability Classification**:
    - Analyzes detected vulnerabilities in the code and classifies them by severity:
      - **Critical**
      - **High**
      - **Medium**
      - **Low**

2. **Security Evaluation**:
    - Determines if the detected vulnerabilities meet the established blocking criteria (e.g., critical or high vulnerabilities).

3. **Brownfield Exceptions**:
    - If the component is identified as **Brownfield**, it can be exempted from blocking criteria under certain conditions, such as creation date or specific attributes.

4. **Actions Based on Results**:
    - **Blocking**: If critical or high vulnerabilities are found and no Brownfield exception applies, the system blocks the deployment.
    - **Warning**: If vulnerabilities are found but the component is Brownfield, a warning is generated instead of blocking.
    - **Unblocking**: If no critical or high vulnerabilities are found, the component is approved, and if it is Brownfield, the exception is deactivated.

---

## Workflow

1. **Vulnerability Filtering**:
    - Filters out vulnerabilities that do not belong to the "Code Quality" kingdom and correspond to the specified tool (`TOOL`).
    - Counts vulnerabilities by severity.

2. **Security Criteria Evaluation**:
    - If vulnerabilities meeting the blocking criteria are found, it evaluates whether the component is Brownfield.
    - If the component is Brownfield, it verifies whether it meets the conditions for applying the exception (e.g., specific dates).

3. **Actions Based on Results**:
    - **Blocking**: If no Brownfield exception applies, the system blocks the deployment.
    - **Warning**: If a Brownfield exception applies, a warning is generated.
    - **Approval**: If no critical or high vulnerabilities are found, the component is approved.

---

## Use Cases

### 1. **Component with Critical or High Vulnerabilities**

    - If the component has critical or high vulnerabilities and is not Brownfield, the system blocks the deployment.

      ```
      The analysis has security <type> with <CRITERIA> or higher criticality.
      ```

### 2. **Brownfield Component with Vulnerabilities**

    - If the component is Brownfield and meets the exception conditions, a warning is generated instead of blocking.

      ```
      The analysis has security <type> with <CRITERIA> or higher criticality but security gate is disabled due to brownfield exception.
      ```

### 3. **Component Without Critical or High Vulnerabilities**

    - If no critical or high vulnerabilities are found, the component is approved.
    - If it is Brownfield, the exception is deactivated.
      ```
      The component is free of blocked security <type>.
      ```
      ```
      The Brownfield exception is going to be disabled because the component does not have critical or high vulnerabilities.
      ```

### 4. **Brownfield Exception Set Over 6 Months Ago**

    ```
    The Brownfield exception was set more than 6 months ago. Disabling the Brownfield attribute.
    ```

---

## What Is a Brownfield Component?

A **Brownfield** component is a legacy or transitioning system that may not fully comply with current security standards. To facilitate its integration, temporary exceptions are allowed under certain conditions.

### Conditions for Brownfield Exception

- The component must be marked as Brownfield in Fortify SSC.
- It must meet the configured dates and attributes.

> **⚠ Warning**  
> Once the component is activated as a Brownfield component, Security Gate will be ready to handle exceptions. This period will be a 6-month long. **It just apply to SCA analysis**

---
