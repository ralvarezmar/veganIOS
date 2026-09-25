<!--helmversion-start-->
```bash
> helm version
version.BuildInfo{
  Version:"v3.6.0",
  GitCommit:"7f2df6467771a75f5646b7f12afb408590ed1755",
  GitTreeState:"clean",
  GoVersion:"go1.16.3"
}
```
<!--helmversion-end-->

<!--openshift-start-->
```bash
> oc version
oc v3.11.0+0cbc58b
kubernetes v1.11.0+d4cacc0
```
<!--openshift-end-->

<!--helmreferences-start-->
- [Helm - The package manager for Kubernetes](https://helm.sh/)
- [Helm - Getting Started](https://helm.sh/docs/chart_template_guide/getting_started/)
- [Helm Version Support Policy](https://helm.sh/docs/topics/version_skew/)
- [Helm Commands](https://helm.sh/docs/helm/)
<!--helmreferences-end-->

<!--helmupgrade-start-->
Install or Upgrad Darwin Nodejs with this Helm Chart:

```sh
helm upgrade --install --history-max 2 darwin-nodejs --set name=darwin-nodejs --set image.registry=registry.global.ccc.srvb.bo.paas.cloudcenter.corp --set image.repository=san-narq-ref/nodejs/darwin-nodejs-app --set darwin.configType=cm-secret --set image.tag=1.0.2 --set replicaCount=1  --set darwin.gitRepo=https://github.alm.europe.cloudcenter.corp/sanes-darwin-poc/poc-certificates.git --set darwin.version=3.0.0 --set darwin.technologyVersion=16 .
```

With the following result:

```sh
Release "darwin-nodejs" has been upgraded. Happy Helming!
NAME: darwin-nodejs
LAST DEPLOYED: Thu Apr 27 12:37:38 2023
NAMESPACE: sanes-darwin-dev
STATUS: deployed
REVISION: 6
TEST SUITE: None
NOTES:
darwin-nodejs configured successfully by nodejs Helm Chart.

Darwin Nodejs Enabled!!

To learn more about the release, try:

  $ helm status darwin-nodejs
  $ helm get all darwin-nodejs
```
<!--helmupgrade-end-->

<!--installnode-start-->
By default, the deployment name is composed of the union of {release-name}-{chart-name}. The name can be overridden by using the _nameOverride_ or _fullnameOverride_ properties, if both properties are set _fullnameOverride_ takes precedence.

```text
For example "darwin-nodejs" is the release name.

* By default:

  >  helm install darwin-nodejs --set darwin.region=bo1 --set darwin.spring.cloud_config.git.uri=git@github.alm.europe.cloudcenter.corp:sanes-darwin-config/configurationnew.git .

   Generated names will look like as follows 'darwin-nodejs-config-server'.

* If "nameOverride" is set the name should be included with the release name. For example:

  > helm install darwin-nodejs --set nameOverride=whatever --set darwin.region=bo1 --set darwin.spring.cloud_config.git.uri=git@github.alm.europe.cloudcenter.corp:sanes-darwin-config/configurationnew.git .

   Generated names will look like as follows 'darwin-nodejs-whatever'.

* If "fullnameOverride" is set it should take precedence and the name should look like:

  > helm install darwin-nodejs --set fullnameOverride=mycostumname --set darwin.region=bo1 --set darwin.spring.cloud_config.git.uri=git@github.alm.europe.cloudcenter.corp:sanes-darwin-config/configurationnew.git .

  Generated names will look like as follows 'mycostumname'.
```
<!--installnode-end-->

<!--renderchart-start-->
Render chart templates locally and display the output.

> **IMPORTANT**: Any values that would normally be looked up or retrieved in-cluster will be faked locally. Additionally, none of the server-side testing of chart validity (e.g. whether an API is supported) is done.
> **Tip**:  Some arrays and dictionaries are commented out in the values.yaml file and for this reason we need to use --set to set the values needed to execute the template command successfully.

Below, you can see the mandatory parameters needed.This chart needs values for mandatory variables:

- image.repository: Darwin NodeJS image to deploy.
- image.version: Darwin NodeJS image version.

```bash
> helm template nodejs-release-name --set name=nodejs --set image.registry=an-registry --set image.repository=an-image --set image.version=1.0.0 --debug .
```
<!--renderchart-end-->
