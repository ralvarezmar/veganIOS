# Breaking Changes in Angular 9

- Angular 9 compiles with ***Ivy*** by default.
- Importing modules via ***string*** has been **removed**
- Typescript: 3.4 and 3.5 are no longer supported, you must upgrade to 3.6.
- The ***tslib*** package is now a ***peerDependency*** and must be installed manually via the 'install tslib --save' command - Internationalization (i18n): ***CLDR*** has been changed to **v36.0.0**.
- **Forms**: ***ngForm/ngForm*** is no longer a valid selector. Use ***ng-form/ng-form***.
- **Forms**: ***NgFormSelectorWarning*** has been removed.
- **Forms**: ***FormsModule.withConfig*** has been removed. Use ***FormsModule*** directly.
- Renderer, which was deprecated, has been removed. Use Renderer2.
- ***RenderComponentType***, which was deprecated, has been removed. Use ***RendererType2***.
- ***RootRenderer***, which was deprecated, has been removed. Use ***RendererFactory2***.
- **Service workers**: The deprecated ***versionedFiles*** setting has been removed. Use **files** in the file ***ngsw-config.json***
