# iOS Continuous Integration Library Workflow (`ios-ci-library.yml`)

This workflow simply runs the security and quality workflows in parallel.

- [iOS Quality Library Workflow](./ios-ci-quality-library.md)

- [iOS Security Library Workflow](./ios-ci-security-library.md)

## Trigger

The trigger for this workflow is the push event on any branch of type:

- development
- feature/*
- fix/*
