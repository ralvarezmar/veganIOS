# What's new in Angular 13

## Improvement in Angular Package Format (APF)

Standardized a new and more modern JavaScript file format, ES2020.

Libraries using the latest version of **Angular Package Format** will no longer need to use [ngcc](https://v13.angular.io/guide/glossary#ngcc), making installations faster and lighter applications.

## Improvements in Angular CLI

Standardized the use of cache in the build process, which allowed an optimization of up to 68% in build speed in projects using Angular 13.

Find more information about cache functionality in [official documentation](https://v13.angular.io/cli/cache).

## Improvements in TestBed

DOM elements will be destroyed by default after running each test, bringing more speed to projects.

This behavior can be configured for the entire testing environment through the [**TestBed.initTestEnvironment**](https://v13.angular.io/api/core/testing/TestBed#initTestEnvironment) method.

Also at the module level through method [**TestBed.configureTestingModule**](https://v13.angular.io/api/core/testing/TestBed#configureTestingModule).
