---
title: Migration automation
hide:
  - toc
---

## Bring your Code Repository to Gluon

This workflow allows you to easily transfer your brownfield source repository to Gluon. It will bring to Gluon all your code, commits, tags… but Pull Requests.

## How to access

In order to be able to access and run the migration workflow you will need to contact with Gluon Adoption Team <gluonadoptionteam@santandernet.onmicrosoft.com>

Once your access is managed you will be able to access:
[https://github.com/santander-group-sds-gln/clonerepository](https://github.com/santander-group-sds-gln/clonerepository)

## Requirements and warnings to bear in mind

It is necessary that your component has been previously and properly created in Gluon.
Once your Gluon Component repository has been successfully created on Gluon, please do not push any commit to it before to run the migration workflow.

If you have main branch in your origin repository you must rename your main branch , for instance main_origin or main_alm or whatever Integration branch must exist in your source repository, otherwise you must create it.

You need to own a PAT ( Personal Access Token ) with admin role on your source repository.

Once workflow has properly run the last step will archive your source repository in order to avoid unexpected mistakes, so once you have migrated your code to Gluon you must work on Gluon.

???+ remember

    **IMPORTANT: Pull Requests will not be transferred from your source repository.**

## How to use

Run workflow "WF to clone a repository in another location" with following inputs:

| Name| Mandatory | Description |
| --- | --- | --- |
| src_repo_url | true | Source repository URL |
| dst_repo_url | true | Destination repository URL |
| integration_branch | true |Name of integration (certification) branch in source repository |
| token_src | true | Personal access token ( with admin role ) to access your source repository|

## Audit

You can find some audit labels on your Gluon repository under labels that will provide you info about who migrated the repository, source repository… just in case you need them
