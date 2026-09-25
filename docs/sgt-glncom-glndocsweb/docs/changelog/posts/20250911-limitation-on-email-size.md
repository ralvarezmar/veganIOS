---
title: Alignment of attached report size with Outlook limits in Gluon Testing emails
categories:
  - Testing
date:
  created: 2025-09-11
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

In the Gluon Testing service, the maximum allowed attachment size for report emails was greater than the Outlook maximum allowed attachment size resulting in an error being thrown due to the emails being too big for certain report sizes.

From the [official Microsoft support page](https://support.microsoft.com/en-us/office/reduce-attachment-size-to-send-large-files-with-outlook-8c698842-b462-4a4c-8d53-5c5dd04f77ef):
For Exchange accounts (business email), the default email size limit is 10 MB.

### What's Changing?

The maximum attachment size has been reduced to 9MB down from 20MB. Since the 10MB limit is for both the message and the attachment we leave 1MB of margin for safety. For attachments of greater
size it will stay as it was, showing a message indicating that the report can be viewed on the Gluon Testing Portal.

### Why Is This Important?

To avoid Outlook from rejecting the report email when the mail was bigger than the maximum 10MB allowed.
