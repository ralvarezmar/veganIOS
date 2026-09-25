# Architectural Tests

With a focus on increasing the quality of the software delivery processes that
make up the Santander ecosystem, a verification process (simple, automatic and
extensible) of code/structure consistency of built projects will be adopted as
an integral part of the DevOps treadmill in Java.

For this purpose, we will use the [ArchUnit](https://www.archunit.org/)
framework, a free tool to check the architecture of Java codes, providing
verification of structural dependencies (packages, classes, annotations,
etc...). In addition, it is also possible to analyze adopted conventions and
taxonomies, inheritance and composition, among other assertions.

ArchUnit manages to "abstract" all the power of the Reflections API, in addition
to extrapolating the expected capabilities of tools like AspectJ, Checkstyle or
FindBugs.
