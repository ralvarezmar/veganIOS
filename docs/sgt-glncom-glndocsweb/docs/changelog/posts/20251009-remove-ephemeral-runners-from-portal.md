---
title: Deprecation of ephemeral runners execution from Gluon Testing Portal
categories:
  - Testing
date:
  created: 2025-10-09
tags:
  - Improvement
  - Fix
---

![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

At the beginning of the implementation of the testing workflows we implemented an option in the Gluon Testing Portal to run the tests in ephemerals runners in order to promote their usage.

Now that the implementation of the testing workflows is more robust, we feel that it's time to deprecate this feature since it was a very basic implementation that was not meant to last very long.

There won't be an option to create any new cards configured to be executed in ephemeral runners.
Users who want to execute their tests using this method must do so by executing the workflow directly on the testing repository.

Current existing cards configured to run on ephemeral runners won't be affected by this change.
We urge any user using this cards to start launching their tests from the testing repository instead.

### Why Is This Important?

Since the implementation was not meant to last long it was a bit buggy.
We tried to patch it along the way but lately we found that in order to fix some issues we would need to dedicate too much time and resources to it.
For this reason, we decided that now was a good time to deprecate this feature.
