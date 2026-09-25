---
title: Angular 20 support
categories:
  - Web
date:
  created: 2025-10-20
tags:
  - Feature
---

![Feature](../assets/images/new-features-yammer.png)

### What's Changing?

We are excited to announce **Angular 20 support** across all Darwin components, Web Library, Angular library and @santander framework libraries! This release includes:

**✨ New Angular 20 Support:**

- **Darwin SPA** component with Angular 20
- **Darwin Microfront** component with Angular 20  
- **Angular Libraries** with Angular 20
- **Web Libraries** with Angular 20
- **@santander framework libraries** updated for Angular 20
- **@ng-darwin libraries** updated for Angular 20
- **@ng-darwin-wmf libraries** updated for Angular 20

**🔄 Version Management Changes:**

- **Angular 16 components support is deprecated** and removed from creation options
- **Angular 18 support continues** as the stable LTS option
- **Angular 20 becomes available** as the latest option

### Why Is This Important?

Angular 20 brings significant improvements and new features that enhance developer experience and application performance. By offering Angular 20 support, teams can:

- **🚀 Access Latest Features**: Leverage all the improvements and new capabilities in Angular 20
- **📈 Enhanced Performance**: Benefit from performance optimizations in the latest Angular version
- **🔮 Future-Ready**: Stay aligned with the latest Angular ecosystem and roadmap
- **🛠️ Modern Development**: Use the most current tooling and development patterns

We maintain support for Angular 18 (LTS) while introducing Angular 20 and deprecating Angular 16 to ensure teams stay current with supported Angular versions.

### Migration or Upgrade Notes

**For Existing Components:**

- **Angular 16 components**: Continue working but are no longer supported. [Migration to Angular 20](https://angular.dev/update-guide?v=16.0-20.0&l=1) is recommended
- **Angular 18 components**: No changes required, continue to receive full support. [Migration to Angular 20](https://angular.dev/update-guide?v=18.0-20.0&l=1) is optional but recommended
- **@santander libraries**: Migration may be required to leverage Angular 20 features
- **@ng-darwin libraries**: Migration may be required to leverage Angular 20 features
- **@ng-darwin-wmf libraries**: Migration may be required to leverage Angular 20 features

**For New Components:**

- Angular 20 is now available as an option during component creation
- Angular 18 remains available as the stable LTS option
- Angular 16 is no longer available for new component creation

### Potential Impact or Risks

- **Deprecation Notice**: Angular 16 components are immediately deprecated and no longer supported
- **Compatibility**: Ensure your existing dependencies are compatible with Angular 20 before migration

### Additional Information

For migration guidance and best practices when upgrading to Angular 20, please refer to the [official Angular documentation](https://angular.dev/update-guide) and our internal guidelines for @santander framework migration.

Teams using Angular 16 components should plan their migration to Angular 18 or 20 to ensure continued support and access to latest features.
