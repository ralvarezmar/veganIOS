---
title: SCF General Support
---

This section provides information on how to request support for Santander Consumer Finance (SCF).
If you have reviewed the documentation and still encounter issues, this guide explains how to open a support ticket.

## Types of Support Tickets

There are two main types of support tickets that can be opened within the ITSM ServiceNow system:

### Incidents (INC)

These tickets are used to report problems or errors encountered. They help address issues that may impact the functionality or performance of the system.

To create an incident:

- Navigate to the incident creation page.
- Set the **Type** to `Support`.
- Set the **Category** to `Applications`.
- Set the **Subcategory** to `Business Applications`.
- Set the **Environment** to `Production`.
- Set the **Application** to `Gluon Platform`.
- Set the **Assignment Group** to `CGS_SCF_CCoE_ITP_OPS`.
In order to assign this group, you may need to switch to the "All" scope by clicking on the magnifying glass icon and selecting "All".

When opening an **Incident (INC)**, ensure you provide a detailed description of the issue, including steps to reproduce it, expected behavior, and actual behavior. This information will help the support team resolve the issue efficiently.

### Requests (REQ)

These tickets are used to request specific actions or services related to SCF, such as configuration changes, improvements or access requests.
Any request for enhancements or changes must include approval from the Gluon Champion as part of the submission.

To create a request, use the following link:
[Request Form](https://santander.service-now.com/com.glideapp.servicecatalog_cat_item_view.do?v=1&sysparm_id=7c3518511bc36150e4909753b24bcbb8&sysparm_link_parent=ce17fabcdb5df7807f668c994b961938&sysparm_catalog=719aafd0db031f448c6c7cde3b9619f8&sysparm_catalog_view=catalog_technical_catalog&sysparm_view=text_search).

When opening a **Request (REQ)**, ensure the request aligns with the supported actions listed in the SCF Technical Catalog, and select **General Support** as the type of request.
Provide a clear description of the requested action, including any relevant details or documentation that may assist in processing the request.

## Important Notes

For the creation of IAM users and roles required for executing workflows, please refer to the [AWS Credentials Guide](./credentials.md).
This guide provides detailed instructions on setting up the necessary permissions and configurations.
