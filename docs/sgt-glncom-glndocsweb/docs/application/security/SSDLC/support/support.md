# FAQ

## Validation/Acceptance of Software

The Gluon security workflows include a Security Gate to ensure SSDLC compliance for each software component. The Security Gate result will fail in the following cases:

<div class="steps" markdown>

• **The SAST scan identifies critical/high security weaknesses.**

• **The SCA scan detects the use of software components (libraries) with critical/high vulnerabilities.**

• **The DAST scan identifies critical/high security weaknesses.**

</div>

The Security Gate ensures compliance with the Corporate Cybersecurity Policy:

> **⚠ Warning**  
> Once the component is activated as a Brownfield component, Security Gate will be ready to handle exceptions. This period will be a 6-month long. **It just apply to SCA analysis**

• If the software being developed or deployed has new critical or high vulnerabilities, the upload cannot be approved. According to the Santander Group's corporate policy, "Cybersecurity Requirements Policy,"
no code with critical or high vulnerabilities can be uploaded to production (section 6.2.6). These vulnerabilities must be remediated (after reviewing potential false positives with the team, Product Owner, or CISO teams).
If remediation is not possible, a waiver must be requested with detailed action plans and resolution dates (to be approved by the entity's CISO), or the risk must be assumed (also requiring approval from the entity's CISO).

• If a third-party component has critical or high vulnerabilities, the upload cannot be approved. According to the Santander Group's corporate policy,
"Cybersecurity Requirements Policy," no code with critical or high vulnerabilities can be uploaded to production (section 6.2.6).
These vulnerabilities must be remediated (e.g., by using a new version of the third-party component or finding alternatives).
If remediation is not possible, a waiver must be requested with detailed action plans and resolution dates (to be approved by the entity's CISO), or the risk must be assumed (also requiring approval from the entity's CISO).

## FAQ

#### How can CISO teams across entities access their entity's Fortify projects and reports?

If you are part of the local entity CISO team and require access to component reports, you need to contact your company owner to be added to the entity security group. You can find the company owner entity list at [Company Owners List](https://gluon.gs.corp/community/docs/latest/application/users-teams/user-roles/#company-owners-list).

#### We have passed the SCA in a project, and it shows a report URL to Sonatype, but we don’t have access

Access to the Sonatype report is not required. The report can be viewed in Fortify SSC.

#### Who can mute/flag false positives?

Only users in 'Security management exception' team can flag false positives for all types of vulnerabilities. If the "suppress" button in the Fortify SSC interface is disabled, it means that the user is not in 'Security management exception' team.

#### What should I do if someone needs to belong to the 'Security management exception' team?

If someone needs to be part of this group, please contact your CISO.

#### Do they need to validate mutes with Detect Service Support?

No, it is the responsibility of the Product Owner, Development teams, and Technical Leads to identify and justify false positives. However, the actual flagging and suppression of these issues should be performed by the CISO team.
A technical justification must be included in the modal that appears for adding comments in Fortify SSC.

It is necessary to follow the internal procedure within your entity.

> **Global SSDLC Team:**  
> In the continuous effort to improve the security of software components, Fortify mute (suppress) permission is only available to the members of the entity Security Exception Management Team at Gluon. This change only applies to Gluon software components.
> Contact your CISO Entity team if you need more information about the new procedure.

#### If we have blocked issues, should they be validated by Detect Service Support?

No, exceptions and reviews should be performed by your entity's CISO or internal SSDLC/Security Champion teams.

#### If we want to include additional users to review the results in the project, can I open a ticket?

You need to add the user to the specific application in Gluon. Within approximately 20–40 minutes, access to Fortify SSC will be available.

#### Why does the workflow Security Gate sometimes finish as OK even if I have weaknesses marked as high?

This is because there are issues considered "quality" by Fortify. These issue types are excluded from the Security Gate by default.

#### Why are false positives sometimes not applied when generating a new version or creating a report in Fortify SSC?

When making any changes to the issues on the audit screen, you need to click on the orange arrows that appear in the upper-right area to confirm the change.
This change is usually applied automatically, but it is recommended to click on the orange arrows to ensure it is applied.
