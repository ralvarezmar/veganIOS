# Commits pattern

Before running the 'afe version' command, it is necessary to have made one or more commits to the repository, following a prefix nomenclature

If you use the default configuration, not overriding the ***version.types*** property of ***afe.json***, use the nomenclature below when making commits

Following [Conventional Commits](https://conventionalcommits.org) we have the following commit patterns that will influence the generation of the CHANGELOG

## Fixes

You should use the ***fix:*** prefix before the commit message

``` BASH
git commit -m "fix: behavior fixing"
```

Resulting in:

```md
## 5.7.1 (2020-02-06)

### Fixing

* behavior fixing
```

> Note: Don't forget the space between the ***fix:*** prefix and the change description

## What's New

You should use the ***feat:*** prefix before the commit message

``` BASH
git commit -m "feat: New Functionality"
```

Resulting in:

```md
## 5.8.0 (2020-02-06)

### News

* New Functionality
```

> Note: Don't forget the space between the ***feat:*** prefix and the change description

## Deprecations

You must use the prefix ***deprecated:*** before the commit message

``` BASH
git commit -m "deprecated: Component `X` was deprecated, use `Y`"
```

Resulting in:

```md
## 5.7.1 (2020-02-06)

### Deprecations

* Component `X` was deprecated, use `Y`
```

> Note: Don't forget the space between the ***deprecated*** prefix and the change description

## Breaking Changes

You must have the prefix in the footer of the message: ***BREAKING CHANGE:*** or concatenate the character ***!*** in the commit type (***fix*** or ***feat***)

``` BASH
git commit -m "feat: New feature with Breaking Change" -m "BREAKING CHANGE: Message Customization"
```

Resulting in:

```md
## 6.0.0 (2020-02-06)

### BREAKING CHANGES

* Message customization

### Fixes

* New functionality with Breaking Change
```

> **Note**
>
> Don't forget the space between the ***BREAKING CHANGE:*** prefix and the Breaking Change customization message

If you do not use the footer with the prefix ***BREAKING CHANGE:*** the BREAKING CHANGE message will be the same as in the description

``` BASH
git commit -m "feat!: New feature with Breaking Change"
```

Resulting in:

```md
## 6.0.0 (2020-02-06)

### BREAKING CHANGES

* New functionality with Breaking Change
### Fixes

* New functionality with Breaking Change
```
