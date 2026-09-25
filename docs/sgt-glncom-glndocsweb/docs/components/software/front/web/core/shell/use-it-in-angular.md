# Use it in Angular

## Capabilities

### Add a SanMicrofront Component

This feature enables the shell to seamlessly integrate a WebComponent as a microfrontend through a template, making the loading process transparent to the developer.

## Installation

Install the Shell library:

```bash
npm install @santander/shell
```

## Usage

### Darwin

```html
<san-microfront [config]="config">
</san-microfront>
```

```typescript
class DarwinMfe implements OnInit {
  config: any;

  ngOnInit(): void {
    this.config = {
      type: LoadPluginType.Darwin,
      remoteEntry: [
        'http://localhost:4201/polyfills.js',
        'http://localhost:4201/styles.js',
        'http://localhost:4201/vendor.js',
        'http://localhost:4201/main.js',
      ],
      tag: 'mex-rost-demomfedw',
    } as MicrofrontConfigDarwin;
  }
}
```

### React ODS

```html
<san-microfront [config]="config">
</san-microfront>
```

```typescript
class ReactOdsMfe implements OnInit {
  private _loginService = inject(LoginService);

  ngOnInit(): void {
    this._loginService.dataChanged.subscribe((value: any) => {
      if (value.accessToken) {
        this.config = {
          type: LoadPluginType.ODS,
          render: SanMicrofrontRender.DOM,
          projectId: 'mb-ui',
          verticalId: 'cards',
          variant: 'us',
          initializers: {
            data: {
              sessionData: {
                accessToken: value.accessToken,
                refreshToken: value.refreshToken,
                expiresIn: value.expiresIn,
                sessionExpiresAt: value.sessionExpiresAt,
                username: value.username,
              },
            },
          },
        } as MicrofrontConfigODS;
      }
    });
  }
}
```

### React Vite

```html
<div #placeholder></div>
```

```typescript
class ReactViteMfe implements OnInit {
  @ViewChild('placeholder', { static: true }) containerRef!: ElementRef;

  ngOnInit(): void {
    loadRemoteModule({
      type: 'module',
      remoteEntry: 'http://localhost:5174/assets/remoteEntry.js',
      exposedModule: './MfeApp',
    }).then((m) => {
      ReactDOM.render(m.default(), this.containerRef.nativeElement);
    });
  }
}
```
