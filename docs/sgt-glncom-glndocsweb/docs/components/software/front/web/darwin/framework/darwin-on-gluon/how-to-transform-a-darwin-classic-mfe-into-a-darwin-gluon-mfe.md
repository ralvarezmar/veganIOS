# How to transform a Darwin Classic Microfront into a Darwin Gluon Microfront

A Darwin Classic Microfront is a Microfronts that uses the following classic Darwin modules:

- [Darwin Config](../ng-darwin/modules/config/index.md){:target="_blank"}
- [Darwin Logger](../ng-darwin/modules/logger/index.md){:target="_blank"}
- [Darwin Security](https://automatic-doodle-rew2y31.pages.github.io/modules/_ng-darwin_security.html){:target="_blank"}
- [Darwin Microfront](../microfrontend-architecture/ng-darwin-wmf/index.md){:target="_blank"}

This way, a Classic Microfront follows the classic corporative security using BKS tokens that are managed by the Shell and offered to the Microfront through the Darwin Security Lite module.
This module is in charge of retrieving the BKS token from the Session storage and injecting it into the HTTP requests.

A Darwin Gluon Microfront is a Darwin Microfront that, instead of injecting the BKS token into the HTTP requests, leverages on the Shell to do that.
Darwin Gluon Microfronts will use the Gluon HTTP library to convert the HTTP requests into custom events that are sent to the Shell. The same Gluon HTTP library, but in the Shell context, will listen to these custom events and convert them into HTTP requests.

As these requests will be performed at the Shell scope, the SCM will intercept them and inject the appropriate access token.

This way, a Gluon Microfront will use the following modules:

- [Darwin Config](../ng-darwin/modules/config/index.md){:target="_blank"}
- [Gluon HTTP library](../../../core/http/index.md){:target="_blank"}
- [Darwin Microfront](../microfrontend-architecture/ng-darwin-wmf/index.md){:target="_blank"}

Unless Microfronts don't know anything about the Security Context Manager, because it runs at the Shell scope, you can have [more details about it here](../../../core/security/index.md)

## How to transform a Darwin Classic Microfront into a Darwin Gluon Microfront

To transform a Darwin Classic Microfront into a Darwin Gluon Microfront, you must follow the next steps:

### 1. Remove the Darwin Security module from the project

Uninstall the Darwin Security module from your project:

```bash
npm uninstall @ng-darwin/security
```

### 2. Remove every reference to `@ng-darwin/security` in your code

You'll need to remove each reference to the Darwin Security module in your code. Every project is different so the best way to find the references in your code will be using the finding tool of your IDE.

Probably you will have references in your `app.config.ts`.

``` typescript title="app.config.ts"
import { provideSecurityLite } from '@ng-darwin/security';

export const appConfig: ApplicationConfig = {
  providers: [
    provideSecurityLite(),
    ...
  ]
};
```

As well as in your `app.ts`.

``` typescript title="app.ts"
import { provideSecurity } from '@ng-darwin/security';

@Component({...})
export class App extends MicrofrontDirective {
  private _securityLiteService = inject(SecurityLiteService);

  override async ngOnInit(): Promise<void> {
    await this._securityLiteService.initialize();
  }

  private _subscribeToSessionEvents(): Subscription {
    return this._securityLiteService.onSessionInitialized$.subscribe(() =>
      console.log('%cMicrofront: onSessionInitialized', 'background: lightgreen') /* eslint-disable-line no-console */
    );
  }
  ···
}
```

Remove it from the Shell lite configuration as well.

``` typescript title="shell-lite.config.ts"
import { provideSecurity } from '@ng-darwin/security';

export const shellLiteConfig: ApplicationConfig = {
  providers: [
    provideSecurity(),
    ...
  ]
};
```

And from the Shell lite component

``` typescript title="shell-lite.ts"
import { SecurityService } from '@ng-darwin/security';

@Component({...})
export class ShellLite extends MicrofrontContainerDirective {
  private _securityService = inject(SecurityService);

  async ngOnInit(): Promise<void> {
    if (channel) {
      this._securityService.setChannel(channel);
    }
    await this._securityService.initialize();
    ...
  }

  private _subscribeToSessionEvents(): void {
    this._securityService.onSessionInitialized$.subscribe(() =>
      console.log('%cShellLite: onSessionInitialized', 'background: lightgreen')
    );
    this._securityService.onSessionAboutToTimeout$.subscribe(() =>
      console.log('%cShellLite: onSessionAboutToTimeout', 'background: khaki')
    );
    this._securityService.onSessionTimeout$.subscribe(() =>
      console.log('%cShellLite: onSessionTimeout', 'background: tomato')
    );
    this._securityService.onSessionResume$.subscribe(() =>
      console.log('%cShellLite: onSessionResume', 'background: lightgreen')
    );
    this._securityService.onSessionKilled$.subscribe(() =>
      console.log('%cShellLite: onSessionKilled', 'background: tomato')
    );
  }
  ...
}
```

Remove it also from `webpack.config.js`

``` typescript title="webpack.config.js"
module.exports = {
  plugins: [
    new webpack.container.ModuleFederationPlugin({
      shared: {
        '@ng-darwin/security': { ... },
        ···
      },
    }),
  ],
};
```

You'll probably have references in other files of your project, so you'll need to find them and remove them.

### 3. Remove Darwin Security configuration from your `config.json`

As you will not have the Darwin Security library, you won't need the security configuration in the `config.json`.

You can safely delete this from your `config.json` and `config-sl.json`

```typescript title="config.json & config-sl.json"
{
  "$schema": "../../node_modules/@darwin/config/schema.json",
  "appKey": "···",
  "appName": "···",
  "logLevel": 1,
  "technicalGrouping": "···",
  "logger": {
    ···
  },
  "security": { <-- REMOVE THIS
    ···
  },
  "app": {
    ···
  }
}
```

### 4. Configure Darwin Logger as insecure

The current version of Darwin Logger is attached to Darwin Security so it must be configured as insecure in order to work without Security.

```typescript title="config.json"
{
  ···
  "logger": {
    "isSecured": false,
    ···
  },
  ···
}
```

We are working on a new version of Logger that will be able to work with the new Security Context Manager (SCM) module so... stay tuned!

### 5. Install and configure the Gluon HTTP module

You'll need to install the [Gluon HTTP module](../../../core/http/use-it-in-angular.md) (`@santander/http-angular`) in your project.

This module, in the Microfront scope, will be in charge of converting the HTTP requests into custom events that will be sent to the Shell.
This module, in the Shell scope, will be in charge of listening to these custom events from the Microfronts and convert them into HTTP requests.

This way, the SCM will be capable of intercepting them and adding the appropriate headers to the request.

You'll need to install it using the following command:

```bash
npm install @santander/http-angular
```

And import and initialize it in the `app.config.ts`.

!!! note

    Please, keep in mind **it requires** having `provideHttpClient()` configured. For example when we are talking about Microfronts, the `provideHttpClient()` provider should be imported in the `app.config.ts` for the scope of the Microfront but also in the `shell-lite.config.ts` for the scope of the Shell Lite.

```typescript title="app.config.ts"
import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { RequestToEventConverterModule } from '@santander/http-angular';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(withInterceptorsFromDi()),
    importProvidersFrom(RequestToEventConverterModule.forRoot())
    ...
  ]
};
```

You'll need to configure the Shell Lite in order to listen to those events and convert them into HTTP requests, so you'll need to import and initialize the `CustomEventListenerModule` in the `shell-lite.config.ts` file.

```typescript title="shell-lite.config.ts"
import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { CustomEventListenerModule } from '@santander/http-angular';

export const shellLiteConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(withInterceptorsFromDi()),
    importProvidersFrom(CustomEventListenerModule.forRoot())
    ...
  ]
};
```

If you want to know more about this HTTP module, you can read the [Gluon HTTP module documentation](../../../core/http/index.md).

If you want to configure the new security model in your microfront, you will need to install the [Gluon Security module](../../../core/security/index.md) (`@santander/security-angular`) in your project.
You can follow steps 5 and 6 from the [How to transform a Darwin Classic Shell into a Darwin Gluon Shell](how-to-transform-a-darwin-classic-shell-into-a-darwin-gluon-shell.md) guide, and apply them to shell lite module and component:

- [Install and configure the Security Context Manager (SCM) module](how-to-transform-a-darwin-classic-shell-into-a-darwin-gluon-shell.md#5-install-and-configure-the-security-context-manager-scm-module)
- [Configure the SCM guard to secure your routes](how-to-transform-a-darwin-classic-shell-into-a-darwin-gluon-shell.md#6-configure-the-scm-guard-to-secure-your-routes)

### 6. Ensure you are using Puppeteer to run your tests

Gluon runners do not provide Chrome installations, so you'll need to use Puppeteer to run your tests in the CI/CD workflows.

Take a look if you are using Puppeteer already. If not, you'll need to install it and configure it.

Follow this short guide to do it: [How to configure Puppeteer to run your tests](../../../core/faq/how-to-use-puppeteer.md).

### 7. Ensure you are using Flame

From Gluon we encourage all the projects to use Flame to standardize the look'n feel of the applications.

Flame is composed of three layers:

- Flame Design System (`@santander/flame-ds`): A set of CSS/SCSS with option and semantic tokens ready to be used, as well as the corporative icons and fonts of Santander.
- Flame User Interface (`@santander/flame-ui`): A set of reusable components developed with Stencil and compiled as standard Web Components.
- Flame User Interface for Angular (`@santander/flame-ui-angular`): A wrapper of `@santander/flame-ui` ready to be used in Angular projects.

You can find more information about Flame in the [Flame documentation](../../../../../../../contribute/cop/flame/index.md).

You can install them in your project using the following commands:

```bash
npm install @santander/flame-ds @santander/flame-ui @santander/flame-ui-angular
```

Once you have installed them, you'll need to configure your project to load the Flame Design System styles.
You have a lot of different possibilities, but we recommend adding them to the `angular.json` file this way:

```JSON title="angular.json"
{
  ···
  "projects": {
    "my-demo-project": {
      ···
      "architect": {
        "build": {
          ···
          "options": {
            ···
            "styles": [
              ···
              "node_modules/@santander/flame-ds/index.css"
            ],
            ···
          },
```

This way, Angular will load Flame Design System styles in the `index.html` file, so all the tokens, fonts and icons will be available for your project.

!!! note

    Please note, `node_modules/@santander/flame-ds/index.css` contains the following inner CSS:

    ``` CSS
    @import "src/tokens.css";
    @import "src/icon-tokens.css";
    @import "src/icon-font.css";
    @import "src/font.css";
    ```

    So you can import them separately if you want, especially if the weight of fonts or icons is too much for your project.

Once you have flame-ds in place, you'll be able to use it. For example try this in your root component. You'll be able to see a new green dashed border.

```SCSS
:host {
  display: block;
  border: 5px dashed var(--color-border-success);
}
```

![Sample flame-ds usage](../../../../assets/images/darwin/sample-flame-ds-usage.png)

The next step is to configure and use the reusable components library we have installed: Flame User Interface for Angular (`@santander/flame-ui-angular`).

We'll need to import the Flame providers from `FlameStencilAngularModule` into your config file.

```typescript title="app.config.ts"
import { FlameStencilAngularModule } from '@santander/flame-ui-angular';

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(FlameStencilAngularModule)
    ...
  ]
};
```

Once you have imported the providers you will need to import the `FlameStencilAngularModule` to use the Flame components in your Angular components.

```typescript title="your-comp.ts"
import { FlameStencilAngularModule } from '@santander/flame-ui-angular';

@Component({
  selector: 'app-your-comp',
  imports: [
    FlameStencilAngularModule
    ...
  ],
  template: `
    <san-modal
        modal-title="Title"
        modal-text="Lorem ipsum dolor sit amet."
        primary-btn-text="Accept"
        secondary-btn-text="Cancel">
    </san-modal>
  `
})
export class YourComp {}
```

And they will render as expected.

![Sample flame-ui-angular usage](../../../../assets/images/darwin/sample-flame-ui-angular-usage.png)
