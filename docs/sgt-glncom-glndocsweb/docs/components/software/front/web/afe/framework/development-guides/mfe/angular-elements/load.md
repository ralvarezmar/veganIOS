# How to load an Angular Element

In order for a **_Angular Element_** to be used correctly in an application, it must be loaded and rendered in the base application.

In this article, you will understand how to do this integration efficiently.

## Identifying the file that needs to be uploaded

The **_Angular Element_** is nothing more than an Angular application encapsulated inside a Web Component (or Custom Element).

When compiled, the scripts necessary for its operation are generated in the **bundle.js**, available when the 'singleBundle' option is enabled as 'true' in **angular.json**, having all the necessary resources for **_Angular Element_** to be loaded correctly.

Assuming there is a url that provides the same, you can consume the resource as follows:

| Standard Url | Url to consume the Angular Element |
|--------|----------|
| myproject.com/my-mfe/ | myproject.com/my-mfe/bundle.js |

If you are developing a local environment, serve the 'dist' folder, after compiling the project using the command:

```bash
http-server ./dist -p 4444
```

And use the **<http://localhost:4444/bundle.js>** address to consume the **_Angular Element_** locally.

> You can also use the **main.js, vendor.js, and runtime.js** files separately, but the bundle.js is the file that contains all the resources you need for the _Angular Element_ to work.
>
> To better understand how a **_Angular Element_** is distributed, [access our official documentation on our build tool](../../../architecture-libraries/afe/devkit-angular/v2/builders/browser/index.md).

## Loading the **_Angular Element_** statically

Now that you know which url to use to load the **_Angular Element_**, you will understand in this section how to load it within an application. Inside the repository, find the **index.html** file.

> Usually sits in 'src/index.html' Add a script tag in the body of the page.

Check out the example below:

```HTML
<!doctype html>
<html lang="en">
<head>
  ...
</head>
<body>
  ...

  <!-- Carrega o Angular Element -->
  <script src="myproject.com/my-mfe/bundle.js"></script>
</body>
</html>
```

That's it, the Angular Element is now loading.

## Loading the **_Angular Element_** dynamically

If you want to load the **_Angular Element_** dynamically, you can use the 'document.createElement' method to download a new script and create an HTML element to add the _Angular Element_ to the DOM.

``` TS
import { Component, Renderer2, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/common';

@Component({
  selector: 'app-my-componente',
  template: '<div #container></div>',
})
export class LoadMFEComponent {
  constructor(private renderer: Renderer2, @Inject(DOCUMENT) private document: Document) {
    this.loadMFEScripts();
  }

  loadMFEScripts() {
    const script = this.renderer.createElement('script');
    script.type = 'text/javascript';
    script.src = 'myproject.com/my-mfe/bundle.js';
    this.renderer.appendChild(this.document.body, script);

    script.onload = () => this.createMFEInstance();
  }

  createMFEInstance() {
    const element = this.renderer.createElement('my-mfe');
    this.renderer.appendChild(this.document.body, element);
  }
}
```

The above code is for reference only. We recommend that it be adapted according to the needs of the channel and also moved to a service that can be reused by the channel.

## Rendering the **_Angular Element_**

Now that you're loading the **_Angular Element_** into the reference application, it's time to render it.

Create a new Angular component in the application that will be responsible for rendering the **_Angular Element_**.

``` TS
//features/my-mfe/my-mfe.component.ts
@Component({
  selector: 'app-my-mfe',
  templateUrl: './my-mfe.component.html'
})
export class MyMfeComponent { }
```

``` HTML
<!-- features/my-mfe/my-mfe.component.html -->
<!-- Renderiza o Angular Element -->
<my-mfe-element></my-mfe-element>
```

Perfect! Now create the routing for the Angular component you just created.

``` TS
//app.routes.ts / app-routing.module.ts
export const routes: Routes = [
    ...
    {
        path: 'my-mfe',
        component: MyMfeComponent
    },
];
```

Don't forget to add the `router-outlet` component in an html file of the application.

> The 'router-outlet' component represents the target of the component that will be rendered by routing.

## Enabling Support for Web Components

As a last step, you'll need to add a special configuration so that Angular doesn't trigger an error when it identifies the **_Angular Element_** (which is a Web Component).

Add the _schema_ [CUSTOM_ELEMENTS_SCHEMA](https://angular.io/api/core/CUSTOM_ELEMENTS_SCHEMA) to the application module or component.

This change will vary depending on the version of Angular that the reference application is using and also whether it is using [Standalone API](https://angular.io/guide/standalone-components).

If your application is using versions below Angular 14, follow this configuration:

``` TS
//app.module.ts
@NgModule({
  ...
  schemas: [
    CUSTOM_ELEMENTS_SCHEMA
  ],
})
export class AppModule {};
```

But if your application is using Angular 14 or above and also using the [Standalone API](https://angular.io/guide/standalone-components), follow this configuration:

``` TS
//features/my-mfe/my-mfe.component.ts
@Component({
  selector: 'app-my-mfe',
  standalone: true,
  templateUrl: './my-mfe.component.html',
  schemas: [
    CUSTOM_ELEMENTS_SCHEMA
  ],
})
export class MyMfeComponent { }
```

In both scenarios, you'll need to add the _schemas_ configuration to the application.

``` TS
schemas: [
  CUSTOM_ELEMENTS_SCHEMA
],
```
