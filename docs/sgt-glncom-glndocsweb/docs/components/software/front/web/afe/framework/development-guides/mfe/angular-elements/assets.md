# How to configure angular ***environment*** for assets

## Setting up ***environment*** dev

Open the ***environment.ts*** file which is located in the following path:

`\[your-project\]\projects\\[your-project\]\src\environments\environment.ts`

Add the following code below:

``` JS
export const environment = {
  production: false,
  url_assets: 'http://localhost:4200/assets',
};
```

> If necessary, replace the ***url_assets*** with the path of the assets used in your project.

## Setting up ***environment*** prod

Open the ***environment.prod.ts*** file which is located in the following path:

`\[your-project\]\projects\\[your-project\]\src\environments\environment.prod.ts`

Add the following code below:

``` JS
export const environment = {
  production: true,
  url_assets: 'https://exemplo.com.br/assets'
};
```

> Replace the ***url_assets*** with the path of the ***assets*** in production used in your project.

## Configuring Component

Open the ***ts*** file of the component that will use the ***assets*** and import the ***environment*** file, the code will look like this:

``` JS
...
import { environment } from '../environments/environment'
...

export class ExemploComponent {
  ...
  url_assets: string = environment.url_assets
  ...
}
```

Open the component's ***html*** file, add the ***assets*** that will be used as follows:

``` HTML
<img src="{{ url_assets }}/images/santander_logo.png" alt="imagem">
```

## Performing the ***build***

To run the build as a dev, simply run the command:

``` BASH
afe build
```

With this, the root path of the ***assets*** will be the same as the one configured in the ***url_assets*** that is in the ***environment.ts*** file

>e.g. <http://localhost:4200/assets/images/santander_logo.png>

To run the build as prod, simply run the command:

``` BASH
afe build --prod
```

With this, the root path of the assets will be the same as the one configured in the ***url_assets*** file that is in the ***environment.prod.ts*** file

>Ex: <https://exemplo.com.br/assets/images/santander_logo.png>
