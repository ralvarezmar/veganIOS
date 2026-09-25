# Semantic versioning

**Semantic Versioning**, also known as ***Semantic Versioning***, or ***SemVer***, is a versioning pattern where the version structure reflects its changes.

This system defines that each version must follow the following structure: ***X.Y.Z***

Where each letter ***MAJOR***, ***MINOR*** and ***PATCH*** means respectively:

- ***PATCH***: is used when the version contains corrections.
- ***MINOR***: informs that something new has been introduced, but is still backwards compatible with the previous version.
- ***MAJOR***: means that some new or correction was made, but it is no longer backwards compatible, causing the so-called ***Breaking Change***.

Taking as an example a library in version ***1.0.0***.

When making a correction available in this library, we make version ***1.0.1*** available.

A new feature would be made available in version ***1.1.0***.

Any change that will have an impact on the user of this library must be made available in version ***2.0.0***.

To learn more about semantic versioning, see the [semVer documentation](https://semver.org/lang/pt-BR/).

> Every time any piece of architecture brings a ***Breaking Change***, it will be accompanied by documentation explaining how to carry out the code migration.
