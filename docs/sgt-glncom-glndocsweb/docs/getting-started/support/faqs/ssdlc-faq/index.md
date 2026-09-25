---
title: Secure SDLC FAQ
hide:
  - tags
tags: 
    - faqs
search:
  boost: 4
---

## How can Ciso teams across entities access their entity's Fortify projectss and reports?

If the Ciso or Security Champions team of an specific entity are not included in the application users it's possible to be added by default in all the components. The entity is defined by the "Company" and "Country" of each software component that
Gluon gets from APM. Automatically, when an onboarding of a component is performed, permissions are given to the AD groups defined by Detect for each entity. If you want to add some users to the entity's permissions by default, you can open a ITSM to
the [SSDLC support items -> Technical Catalog > Cybersecurity > Detect > SSDLC – SAST Support](https://santander.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_cat_item_view.do%3Fv%3D1%26sysparm_id%3D1e9eca0f1bbc29105ae05532604bcb04%26sysparm_processing_hint%3Dsetfield:request.parent%3D%26sysparm_link_parent%3D3777a2651bc9b7c020044002cd4bcbf5%26sysparm_catalog%3D719aafd0db031f448c6c7cde3b9619f8%26sysparm_catalog_view%3Dcatalog_Technical_Catalog).

## We have passed the SCA in a project and it shows a report URL to Sonatype but we don´t have access

The access to Sonaype report is not required, the report can be shown at Fortify SSC.

## Who can mute/flag false positives?

Only those users who have a "Product Owner" role at Fortify SSC can flag false positives in all types of vulnerabilities. If the "suppress" button in the Fortify SSC interface is disabled, it means that the user's role is Developer.

## Do they need to validate mutes from Detect Service Support?

No, it's the responsibility of the Product Owner, Develop teams or CISO team to identify, flag, and justify false positives. A technical justification should be included in the modal that appears to include comments at Fortify SSC.

## If we have blocked issues, should be validated by Detect Service Support?

No, exceptions and possible reviews should be performed by your entity's CISO or entity internal SSDLC/Security Champion teams.

## If we want to include any more users to review the results in the project, can I open a ticket?

You need to add the user in the specific application at Gluon, and in the following minutes (approx. 20-40min) access at Fortify SSC will be available.

## Why sometimes, even if I have weaknesses marked as high, the workflow security gate finish as OK?

This is because exists issues considered "quality" by Fortify, these issues types are excluded from the Security Gate by default.

## Why are false positives sometimes not applied when generating a new version or when create a report from Fortify SSC?

When make any kind of change to the issues on the audit screen, you need to click on the orange arrows that appear in the upper right area to confirm the change. This change is usually applied automatically, but it is recommended to click on the orange
arrows to force it to be applied.
