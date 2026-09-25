## Version validation

This workflow ensures that a user can't push a version to main if it already exists as a release. It supports the following technologies:

* **Apigee** checking *pom.xml*
* **Apis** checking *api-specification.yml*
* **Appian** checking *pom.xml*
* **Maven** checking *pom.xml*
* **NPM** checking *package.json*

If the version in the file checked already exists as a release, the workflow will fail and the user will get an explanation about which version caused the error.
