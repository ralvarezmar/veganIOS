# Rulesets

A ruleset is a named list of rules that applies to a repository.
When a ruleset is defined at organization level, it can be applied
to all repositories in the organization.

Rulesets are an essential part of many development projects.
Whenever contributors interact with a given codebase on GitHub, it is
well-defined ruleset that prevents them from negatively impacting it.

GitHub rulesets puts safeguards in place to ensure code is kept out of
harm's way during otherwise routine deletions, merges, and review processes.
Without GitHub rulesets, the above and many other factors can wreak
havoc on your codebase, costing your entire team many hours of dedicated work
in the process.

!!! info "Protection Strategy"

    In Gluon, all `default branch` of any component created in Gluon will be
    protected, regardless of the type of component created.

The idea is the need to ensure access to integration branches such as `main`.
These integration branches play a crucial role. The "main" (or "master") branch
usually contains the stable and production version of the project, while the
other branch is used to integrate and test new features before being merged
with the main branch. These branches are vital to maintaining an orderly
development structure and ensuring software stability.

By protecting the default branch in GitHub we get the following benefits:

- __Stability and reliability of production code__: By protecting the "main" branch,
it is guaranteed that only tested and stable changes are merged, which helps
maintain the integrity of the software in production and avoid unwanted
disruptions for users.
__Secure and controlled collaboration__: By setting permissions and restrictions
on the branch, it prevents unapproved or unstable changes from being merged,
ensuring that only tested and validated features are integrated into the main
branch.
- __Improvement in the integration and testing process__: By enabling reviews via
pull requests and setting mandatory approvals, a structured workflow is established
that facilitates the review and testing of changes in the integration branch before
merging, which reduces the probability of errors and conflicts.
- __Registration and traceability of changes__: By using GitHub for branch protection,
there is a detailed record of the activities and changes made, which allows better
traceability and monitoring of the progress of development.
- __Immutable workflows__: By using GitHub for push protection we can protect the
  .github/workflows directory, ensuring that the workflows are not modified or deleted

GitHub allows 75 rulesets per repository.
There are three kinds of rulesets. In gluon we have created one rule for each kind of ruleset.

- [Branch rulesets](gluon-branching-protection.md)
- [Tag rulesets](gluon-tag-protection.md)
- [Push rulesets](gluon-push-protection.md)
