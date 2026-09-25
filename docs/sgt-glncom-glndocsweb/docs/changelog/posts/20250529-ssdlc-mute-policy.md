---
title: Changes in mute policy
categories:
  - Software CICD
  - Security
date:
  created: 2025-05-29
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png){ width=100%}

We are glad to announce an update in the process for managing false positives in Fortify SSC, introducing new procedures and clarifying team responsibilities.

### What's Changing?

- **False Positive Suppression Permission:**  
  Only users who are part of the 'Security management exception' team can now flag (suppress) false positives for all types of vulnerabilities in Fortify SSC.  
  If the "Suppress" button is disabled, it means the user is not part of this team.

- **How to Request Access:**  
  If someone needs to be added to the 'Security management exception' team, they should contact their CISO.

- **Responsibility Clarification:**  
  While Product Owners, Development teams, and Technical Leads are responsible for identifying and justifying false positives, only the team (Security Exception Management) can actually perform the suppression.

- **Internal Procedure Emphasis:**  
  It is necessary to follow your entity's internal procedure for requesting and managing suppressions.

- **Global SSDLC Team Note:**  
  The ability to mute (suppress) vulnerabilities is now restricted to the Security Exception Management Team at Gluon for Gluon software components. For more information, contact your CISO Entity team.

### Why Is This Important?

These changes ensure a more controlled and auditable process for handling false positives, improving the security posture and compliance across teams and entities.

### How to Use This Feature?

- If you need to suppress a false positive, verify that you belong to the 'Security management exception' team.
- If access is required, reach out to your CISO to request inclusion in the appropriate team.
- Always provide a technical justification when flagging a false positive, following your entity's internal process.

!!!Note
    These new procedures apply to Gluon software components. For detailed steps or further assistance, contact your CISO Entity team.
