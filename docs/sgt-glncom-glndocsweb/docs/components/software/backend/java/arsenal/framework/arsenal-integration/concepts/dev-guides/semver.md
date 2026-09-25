# Semantic Version

Adhering to a versioning standard lets you and other developers know exactly
where you are in the software development history.

> Is it possible to "guess" whether a specific version introduced bugfixes or
> new features just by looking at the version number?

Yes! The model recommended here is called Semantic Versioning (or just SemVer)
and will help us answer the above question exactly.

## What is SemVer?

It is a pattern where versions are numbered based on 3 components, in the format
<span
style="color:orange">***&lt;Generation>.&lt;Functionality>.&lt;Correction>***</span>,
where:

* Generation (MAJOR): Indicates that changes have been made that make it
  incompatible with the previous version
* Functionality (MINOR): indicates that new functions have been introduced,
  maintaining compatibility with the previous version
* Correction (PATCH): indicates that in this version there are no news, only bug
  fixes

## How it works?

SemVer is based on incrementing the right component at the right time, that is,
according to the changes being made to the application.

### Corrections

If you are just fixing bugs, this release is categorized as a Patch release and
only the last component should be incremented. Corrections are changes to adjust
incorrect behavior, whether technical or implementation of business rules that
did not follow a certain specification.

Example: 1.1.2 > 1.1.3

### New features

If you are introducing new features in the application, maintaining
compatibility with the previous version, this version is categorized as a
Functionality Inclusion (MINOR) version and only the second component should be
incremented. You can also increment this component if you have removed
functionality or made any substantial improvements (eg performance
improvements).

!!! warning The correction component must be reset when incrementing the
    functionality component! Example: 1.1.3 > 1.2.0

### New Generations

New generations should only be introduced when there is a compatibility break
between the new version and the previous version. This scenario is very common
in libraries (libs) when there is a change in method parameters, and also in
APIs when there is a change in field names or their removal.

!!! warning Correction and functionality components must be reset when
    incrementing the generation component! Example: 1.2.0 > 2.0.0

## Frequently Asked Questions

Now that you know SemVer, let's see some frequently asked questions that may
appear.

### Which version do I start with?

In the SemVer pattern, the initial version is 0.1.0 , not 0.0.1 as you might
imagine. If you think about it, would you agree that you always start with a
feature, not a fix?!

### How are the versions before the first release in production?

Every application goes through a development phase before a first version can go
into production. During this phase, your application remains at version 0.X.Y
and you are free to increment the X and Y components as many times as necessary.
Only change the version to 1.0.0 when the application is ready for the first
production release!

## Practical Application

In a Spring Boot application, the version indication is made in the pom.xml
file, which is found in the root folder of your application.

The version must be completed using the <span style="color:orange">version</span> tag present in the pom.xml file, as shown in
the example below:

``` { .yaml .copy }
<project>
    <groupId>com.santander.ars</groupId>
    <artifactId>arsenal-refarch-account</artifactId>
    <version>0.1.0</version>
</project>
```

## References

1. [Semantic Versioning (SemVer)](https://semver.org/)
