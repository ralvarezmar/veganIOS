# Slow installation of dependencies when running the npm install command

## Contextualization

Slowness during the process of installing project packages when running the 'npm install' command, where the ***fetchMetadata*** step seems to be stuck, not being able to download some dependency.

## Architecture Guidelines

Some applications may encounter the context described above.

In these cases, it is possible that one of the following causes is the problem:

**Mapped scenarios:**

- [Wrong registry configuration***](./wrong-registry.md)
