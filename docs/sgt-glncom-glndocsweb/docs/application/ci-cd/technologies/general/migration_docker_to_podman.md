# **Migration from Docker to Podman**

## **1. Introduction**

We would like to inform our users of an important update in our container
environment. As part of our commitment to providing a secure and
high-performance experience, we will be transitioning from Docker to Podman.

Podman is an open-source, Linux-native tool designed to develop, manage, and
run Open Container Initiative (OCI) containers. It operates without a daemon,
which enhances security and reduces the system footprint.
Podman also provides increased flexibility with features like rootless
containers.

## **2. Motivation of changing**

The Podman architecture is daemonless, unlike Docker which relies on a daemon
for its operations, Podman operates in a daemonless manner. This means there's
no long-running background process that could potentially be exploited by
malicious actors. This daemonless architecture significantly reduces the attack
surface, thereby increasing the security of our container environments.
Other Podman's advantages are as follows:

* It lets you control the layers of the container; sometimes, you want
a single layer, and sometimes you need 12 layers.
* It uses the fork/exec model for containers instead of the
client/server model.
* It lets you run containers as a non-root user, so you never have to give
a user root permission on the host. This obviously differs from
the client/server model, where  you must open a socket to a privileged daemon
running as root to launch a container.

## **3. Essential Information for Users**

The users haven´t impact, the solution is backward compatible. Only the
parameter `DOCKER_BUILD_ARGUMENTS` is deprecated, It is recommended to use
the parameter `CONTAINER_BUILD_ARGUMENTS`.

**Podman features:**

* [Rootles containers with Podman, the basics](https://developers.redhat.com/blog/2020/09/25/rootless-containers-with-podman-the-basics).
* [Podman docs](https://docs.podman.io/en/latest/).
* [Cheat Sheets](https://developers.redhat.com/cheat-sheets/podman-cheat-sheet).
