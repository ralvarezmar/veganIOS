---
title: Ansible deploy failed when user/password contains special characters
categories:
  - Software CICD
date: 
  created: 2025-09-18
tags:
  - Fix
---

![Fix](../assets/images/fix-blog.png)

### What's Changing?

We've resolved a critical issue in the Ansible deployment process that was preventing
successful deployments when user/password credentials contained special characters.

**Technical Changes:**
Aquí tienes el documento corregido manteniendo el formato original:

We implemented a **file-based JSON solution** for passing user/password credentials to Ansible when executing the playbook command.

### Why Is This Important?

This fix ensures that any special characters in credentials are safely passed to Ansible without shell parsing conflicts, resolving the blocking issue for the Gravity team and other teams using special characters in their deployment credentials.

**Problem Impact:**

- This bug was blocking deployments for the Gravity team and potentially affects any deployment requiring user/password credentials with special characters when using Ansible.
- Examples of problematic special characters included: `$`, `&`, `!`, `#`, `%`, `*`, which were being incorrectly interpreted by the shell when passed to Ansible commands.

**Benefits of the Fix:**

After the analysis, we implemented a **file-based JSON solution** for the following reasons:

1. **Reliability**: JSON files are not processed by the shell, avoiding parsing conflicts
2. **Standard compliance**: Ansible natively supports `--extra-vars @file.json`
3. **Automatic escaping**: `JSON.stringify()` handles all special character escaping
4. **Maintainability**: Clean separation between credential handling and command construction
