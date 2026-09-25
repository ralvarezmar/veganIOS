# Use it in Angular

## Capabilities

### Handle the HTTP communication between Shell and Micro Frontend applications

This capability allows the application to handle the HTTP communication between Shell and Microfront applications, by converting all MFE (Microfront) requests into events, so that it can be listened and then executed by the shell.

## Installation

Install the HTTP library for Angular:

```bash
npm install @santander/http-angular
```

## Usage

### Angular Shell

In the `app` folder of your Shell application, find the `app.config.ts` and import the providers `CustomEventListenerModule` provide.

```typescript title="app.config.ts"
export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(CustomEventListenerModule.forRoot())
    ...
  ]
};
```

### Angular Microfront

In the `app.config.ts` of your Microfront, import the providers `RequestToEventConverterModule` provide.

```typescript title="app.config.ts"

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(RequestToEventConverterModule.forRoot())
    ...
  ]
};
```
