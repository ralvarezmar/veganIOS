---
title: Automations in ITSM
---
There are various automated processes in ITSM that monitor the tickets assigned to our resolver groups and carry out the actions described below.

## Automatic Ticket Closure Due to Lack of Response from the Requester

When a Gluon technician requests additional information from the user who opened an ITSM ticket and sets the ticket status to "Waiting for requester," a 3-day countdown begins.
If, during this period, the requester does not respond or provide the requested information, the system will automatically close the ticket.

This process ensures that tickets do not remain open indefinitely due to lack of response from the user.

## Automatic Information Verification Process

All ITSM tickets must include the information requested in the templates. If the ticket does not contain this information, its status will automatically be changed to "Waiting for requester."<br><br>

### Incident template

**- Summary:** Provide a brief description of the problem being reported.<br>
**- Recurrence:** Is the issue transient (occurring once), intermittent (occurring irregularly), or permanent (occurring all the time)?<br>
**- Blocking:** Is it blocking the user? Is it blocking the application? Is it blocking the business?<br>
**- Last Time It Worked:** Provide the date and time of the last successful operation when the service worked without issues.<br>
**- Problem:** Describe the problem causing the incident, including any known issues, bugs, or workarounds.<br>
**- Steps to Reproduce:** Provide a detailed description of the steps taken to reproduce the incident, including specific actions, data used, and any other relevant details.<br>
**- Evidence:** Attach any screenshots, logs, or other evidence that can help diagnose the incident. Include error messages or other relevant information.<br>

### Support template

**- Summary:** Provide a brief description of the support request.<br>
**- Details:** Describe the issue or question in detail. Include any relevant context or background information.<br>
**- Expected Outcome:** What are you trying to achieve or resolve with this request?<br>
**- Priority:** Indicate the urgency of the request: Low, Medium, High, or Critical.<br>
**- Evidence:** Attach any screenshots, logs, or other supporting materials that can help clarify the request<br>
