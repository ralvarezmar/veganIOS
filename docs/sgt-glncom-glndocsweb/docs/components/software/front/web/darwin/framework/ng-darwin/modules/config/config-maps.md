# Config Maps

One of the ways to obtain the `config.json` file with the configuration is through ConfigMaps, an OpenShift/Kubernetes object that provides the injection of configuration data into containers.

[**Here**](https://sanes.atlassian.net/wiki/spaces/DOC/pages/24305075607/Creaci+n+de+ConfigMaps){:target="_blank"} you can find the guide to create the ConfigMaps in OpenShift.

!!! warning
    Do not make use of the `CONFIG_END_POINT` environment variable, which is used to differentiate the use of ConfigMaps or the [Spring Cloud Config](spring-cloud-config.md) service.
