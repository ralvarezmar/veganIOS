# `MountpathPipe`

## Description

Add before the current path the microfront mount path, in case that path and mount path are empty, the root path `/` will be set.

!!! note
    Mount path cannot start with a slash

## Methods

### `transform(currentPath:string)`

Compose the final path from the current value and the mount path

#### returns

The final composed path

## Usage notes

Should be used in any routerLink or route when the Microfront is using a mount path.

``` html
<!-- Knowing that the mountPath value is 'my/mount' -->

<a [routerLink]="'/component/second' | mountPath">Go</a>
<!-- Result: my/mount/component/second -->

<a [routerLink]="'/' | mountPath">Go</a>
<!-- Result: /my/mount -->
```
