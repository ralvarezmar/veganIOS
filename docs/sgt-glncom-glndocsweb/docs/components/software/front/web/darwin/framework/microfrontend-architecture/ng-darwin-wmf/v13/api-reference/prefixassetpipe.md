# `PrefixAssetPipe`

## Description

The `prefixAsset` pipe is in charge of adding a prefix to the input value, in order to Nginx redirections can work and the different Microfronts can be differentiated resulting in loading the assets correctly.

!!! note
    Please note if value starts with a slash, it will be deleted. The path must be a relative path.

## Methods

### `transform(currentPath:string, prefixParam?:string)`

This method will compose the currentPath given with, if prefixParam given, with it, if not, with the technicalGrouping configured.

!!! note
    If this pipe is used without indicating prefixParam and without a technicalGroup set, it will throw a error

#### returns

The final composed path to the asset.

## Usage notes

``` html
<img [src]="'assets/js.png' | asset:'fake-prefix'" />
<!-- The src attribute will be transformed to 'fake-prefix/assets/js.png' -->

<img [src]="'/assets/js.png' | asset:'fake-prefix'" />
<!-- The src attribute will be transformed to 'fake-prefix/assets/js.png' -->

<img [src]="'assets/js.png' | asset" />
<!-- If there is no pipe param, the ConfigService will be mandatory to exist, and the prefix will be the technical grouping retrieved from this service. If ConfigService.config.technicalGrouping is 'f-ng-00000000-xxxx' the src attribute will be transformed to 'f-ng-00000000-xxxx/assets/js.png' -->
```
