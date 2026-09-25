---
title: Improvements into Release Management creation
categories:
  - Release
date:
  created: 2025-06-12
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

While creating a release, several improvements have been added:

- 🔁 **Automatic Retry in Task Creation**  
  Automatically, the creation process checks if all release tasks were created correctly. If there is a failure, it tries to recreate automatically and informs the user about the result, reducing the risk of blocked releases.

- 👥 **Handling unavailable AppOwner/PO**  
   The form only allows progress when all mandatory information is validated concerning AppOwner/PO. Only if he/she  is available in ServiceNow and in the correct group, at the creation moment.

- 📅 **Deploy Window Validation**  
  The system validates release dates and times according to the deployment window configured into the company configuration, preventing scheduling outside the allowed period and displaying the valid rules to the user in the form.

- 🔑 **Creation open to all application members**  
  From now on, any application member and owner can create releases, which increases flexibility.

### Why Is This Important?

The release creation process is not simple. It contains multiple fields and then a complex transaction of generation many items.
This improvement makes the process simpler for the user and guarantees that all release items are generated.
