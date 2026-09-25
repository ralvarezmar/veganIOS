# `PrefixAssetPipe`

## Description

The `prefixAsset` pipe is in charge of adding a prefix to the input value, in order to Nginx redirections can work and the different Microfronts can be differentiated resulting in loading the assets correctly.

!!! note
    Please note if value starts with a slash, it will be deleted. The path must be a relative path.

## Methods

### `transform(value: string, prefixParam?: string): string`

This method will compose the currentPath given with, if prefixParam given, with it, if not, with the technicalGrouping configured from the ConfigService.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `value` | `string` | Value to transform (asset path) |
| `prefixParam` | `string` (optional) | Optional param to prefix the value. If not provided, uses `ConfigService.config.technicalGrouping` |

#### Returns

`string` - The final composed path to the asset.

#### Throws

`DwError` with type `DW_ASSET_PIPE` if no prefix is configured or if the prefix is an empty string.

## Usage notes

```html
<img [src]="'assets/js.png' | prefixAsset:'fake-prefix'" />
<!-- The src attribute will be transformed to 'fake-prefix/assets/js.png' -->

<img [src]="'/assets/js.png' | prefixAsset:'fake-prefix'" />
<!-- The src attribute will be transformed to 'fake-prefix/assets/js.png' -->

<img [src]="'assets/js.png' | prefixAsset" />
<!-- If there is no pipe param, the ConfigService will be mandatory to exist, and the prefix will be the technical grouping retrieved from this service. If ConfigService.config.technicalGrouping is 'f-ng-00000000-xxxx' the src attribute will be transformed to 'f-ng-00000000-xxxx/assets/js.png' -->
```
