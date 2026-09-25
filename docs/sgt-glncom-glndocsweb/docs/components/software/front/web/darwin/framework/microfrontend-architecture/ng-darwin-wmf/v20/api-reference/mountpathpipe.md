# `MountPathPipe`

## Description

Add before the current path the microfront mount path, in case that path and mount path are empty, the root path `/` will be set.

!!! note
    Mount path cannot start with a slash

!!! warning
    Path value has to start with a slash. If not provided, a `DwErrorMountPathPipe` error will be thrown.

## Methods

### `transform(currentPath: string): string`

Compose the final path from the current value and the mount path

#### Parameters

| Name | Type | Description |
|---|---|---|
| `value` | `string` | Current path (must start with '/') |

#### Returns

`string` - The final composed path

#### Throws

`DwError` with type `DW_MOUNT_PATH_PIPE` if the path value doesn't start with a slash.

## Usage notes

Should be used in any routerLink or route when the Microfront is using a mount path.

### Examples

```html
<!-- Knowing that the mountPath value is 'my/mount' -->

<a [routerLink]="'/component/second' | mountPath">Go</a>
<!-- Result: /my/mount/component/second -->

<a [routerLink]="'/' | mountPath">Go</a>
<!-- Result: /my/mount -->
```

### Error Handling

```html
<!-- This will throw a DwError -->
<a [routerLink]="'path' | mountPath">Go</a>
<!-- Error: Path value has to start with a slash -->
```

### Mount Path Scenarios

```html
<!-- When mountPath = '' (empty) -->
<a [routerLink]="'/path/to' | mountPath">Go</a>
<!-- Result: /path/to -->

<!-- When mountPath = 'mount/path' -->
<a [routerLink]="'/path/to' | mountPath">Go</a>
<!-- Result: /mount/path/path/to -->

<!-- When mountPath = 'mount/path' and path = '/' -->
<a [routerLink]="'/' | mountPath">Go</a>
<!-- Result: /mount/path -->
```
