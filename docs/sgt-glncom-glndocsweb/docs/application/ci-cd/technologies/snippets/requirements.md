<!--npm-start-->

The GitHub runner must have:

* Npm with required version for the application.
* Node with required version for the application.
* JDK 11 and Node 12 required for Sonar.  
* JDK 11 required Fortify.
* Podman and Helm installed and configured by default in the system variables.
* Tools: asdf, jq, yq, curl, unzip
* Connectivity to the different tools

<!--npm-end-->

<!--npm-scaff-start-->

The GitHub runner must have:

* Npm with required version for the application.
* Node with required version for the application.
* Tools: asdf, curl
* Connectivity to nexus
* Github App installed in the destination
  organization with read access to metadata; read and write access to actions,
  administration, code, repository projects, and workflows permissions.

<!--npm-scaff-end-->

<!--maven-start-->

The GitHub runner must have:

* Maven with required version for the application.
* JDK with required version for the application.
* JDK 11 and according Node version required for Sonar (default 16).
* JDK 11 required Fortify.
* Podman and Helm installed and configured by default in the system variables.
* Tools: asdf, jq, yq, curl, unzip
* Connectivity to the different tools

<!--maven-end-->

<!--maven-scaff-start-->

The GitHub runner must have:

* Maven with required version for the application.
* JDK with required version for the application.
* Tools: asdf, curl
* Connectivity to nexus
* Github App installed in the destination
  organization with read access to metadata; read and write access to actions,
  administration, code, repository projects, and workflows permissions.

<!--maven-scaff-end-->
