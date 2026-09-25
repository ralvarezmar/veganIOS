# Nomenclature

The standards adopted for naming in Integration Architecture 3.0 are the same as adopted in [Arsenal Backend Nomenclatures,](../../../arsenal-backend/concepts/dev-guides/nomenclature.md) with some additional ones that have particularities of Apache
Camel integration.

## Packages

Package naming is similar to [Arsenal Backend Nomenclature](../../../arsenal-backend/concepts/dev-guides/nomenclature.md)
Backend Nomenclature), with a single different detail shown below:

<span style="color:orange">com.santander.***integration***.&lt;acronym>.caml.&lt;application>.&lt;package></span>

In this case, the word integration was added to give visibility that it is an
integration project.

### Integration Application Classes

In addition to the points presented, the name of the classes must make a direct
reference to the package they belong to. This reference is made by adding a
suffix to the class name, see below:

| Package         | Class Suffix                          |
|-----------------|---------------------------------------|
| builder         | ClassName***Builder***                |
| builder.request | ClassName***RequestBuilder***         |
| config          | ClassName***Config***                 |
| processor       | ClassName***Processor***              |
| route           | ClassName***NomeClasseRouteBuilder*** |

In the examples above, ClassName must be replaced by the actual name of the
class in question (eg Customer).
