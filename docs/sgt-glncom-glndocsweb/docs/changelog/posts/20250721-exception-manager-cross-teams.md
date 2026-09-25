---
title: Enable the use of Cross Teams in Exception Management
categories:
  - Quality
  - Testing
date:
  created: 2025-07-21
tags:
  - Improvement
---

![Improvement](../assets/images/improvement-blog.png)

Now there is the option to register Cross Teams from one company to be able to manage Quality and Testing waivers from itself or other companies.

### What's Changing?

Currently, only a certain team type was able to manage Quality and Testing waivers and only for the company it was registered.
Now, once registered, any team, regardless of type, can be configured in exception manager to be able to manage Quality, Testing or both types of waivers for any company.

### Why Is This Important?

The requirement was raised due to the users not wanting to have to manage multiple identical teams across various companies.
This way, they only need to manage one or two teams from a single company.

![Improvement](../assets/images/improvement-blog.png)

Separate the team type responsible for Quality and Testing waivers management.

### What's Changing?

Previously, QEMT teams were able to manage both Quality and Testing waivers.
This changes with the newly added TEMT team type.
Now, QEMT will only be able to manage Quality waivers while TEMT will only be able to manage Testing waivers.

Cross Teams registered through the Exception Manager API do not need to respect this restriction.

### Why Is This Important?

For security reasons it made no sense that the QEMT (Quality Exception Management Team) was able to manage other types of exceptions.
This will allow for a more fine grained permissions control.
