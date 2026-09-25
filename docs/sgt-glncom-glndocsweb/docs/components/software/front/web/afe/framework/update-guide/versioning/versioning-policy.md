# AFE versioning policy

The ***Front-End Architecture*** also follows [Semantic Versioning](./semantic-versioning.md) standards to have greater control over the functionalities available in the pieces and make clear the impact of each version.

Just like Angular, the versions of our parts follow 3 states:

| Status | Description | Support |
| ------ | --------- | ------- |
| Activate | Current version, where we will make all necessary improvements and corrections | Yes |
| Long Term Support | It will be available for use, but will not receive improvements, **only corrections that impact production** | Yes |
| Depreciated | Use not recommended, as **we do not carry out any type of update** | No |

> These states only take into account the ***MAJOR*** of the version.

## Example

Taking as a base any piece that is in version ***3***.

This ***3*** version is the one we consider active, and will receive new features.

The ***2*** version of this same part would be the LTS, where only emergency corrections will be made.

Version ***1*** is now deprecated and should no longer be used, as it is **no longer** maintained by the architecture.

> The available versions of our components can be found on the [Front-end Architecture parts] page (<https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257378521>).
