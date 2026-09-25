# Android Continuous Integration Library Workflow (`android-ci-library.yml`)

This workflow simply runs the security and quality workflows in parallel.

- [Android Quality Library Workflow](./android-ci-quality-library.md)

- [Android Security Library Workflow](./android-ci-security-library.md)

## Trigger

The trigger for this workflow is the push event on any branch of type:

- development
- feature/*
- fix/*
