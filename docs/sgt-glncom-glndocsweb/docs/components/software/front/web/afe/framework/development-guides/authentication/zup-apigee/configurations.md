# Configurations

After the [prerequisites](pre-reqs.md) step, let's move on to the project configuration.

In the project's ***config*** folder, create a file named ***legacy-auth.
config.ts*** and inside this file create and export a constant with the type ***AuthenticationLegacyConfig***, which is part of the ***sub-library*** ***@afe/authentication/legacy*** specific for coexistence between ***Zup*** and ***Apigee***

Below is an example of this configuration file:(config/legacy-auth.config.ts)

``` TS
import { AuthenticationLegacyConfig } from "@afe/authentication/legacy";

export const legacyAuthConfig: AuthenticationLegacyConfig = {
    urlsToIntercept: ["/apigee-url"],
    urlLogin: "/hub-url/auth_convivencia/v2/token",
    urlLogout: "/hub-url/auth_convivencia/v2/logout",
    appKey: "<YOUR_APP_KEY>",
    clientId: "",
    zupAppKey: "<YOUR_ZUP_APP_KEY>",
};
```

> ❗ **Notes**
>
> The variables in the following example should be replaced with the respective values of your project.
>
> `<YOUR_APP_KEY>` - ***app-key*** of your application in ***Apigee GHS***;
>
> `<YOUR_CLIENT_ID>` - This value is no longer used and can be populated with an empty ***string***.
>
> `<YOUR_ZUP_APP_KEY>` ***app-key*** of your application in Zup.
>
> The ***appKey*** is obtained when creating the application in Apigee for product consumption, which should be requested via [Jira do CDG](https://confluence.santanderbr.corp/display/PADROESARQINT/Suporte)
>
> ⚠️ ***Notes***
>
> Check more details about the idleTimeout property in the "[Session Refresh Policy" section](../refresh-policy.md).
>
> The version of the [coexistence login](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=442480400) used should be aligned with the integration architecture team, however, the ***v1 coexistence*** ***API***
> should not be used due to security vulnerabilities found in the resource.
>
> After the mentioned configurations, import the ***AuthenticationLegacyModule*** from the ***@afe/authentication legacy***
> package into the main module of the application, passing the ***legacyAuthConfig*** constant imported from the ***legacy-auth config.ts*** file to its ***forRoot*** method.

File: app.module.ts

``` TS
import { AuthenticationLegacyModule } from "@afe/authentication/legacy";
import { legacyAuthConfig } from "./config/legacy-auth.config";

@NgModule({
  declarations: [
    // code omitted
  ],
  imports: [AuthenticationLegacyModule.forRoot(legacyAuthConfig)],
  bootstrap: [
    // code omitted
  ],
})
export class AppModule {}
```

## Proxy Configuration

To consume ***Apigee*** services, a different configuration for your ***proxy*** in the ***proxy.conf.json*** file is required.
The headers property should be added, and its value should be an object with the origin property set to localhost, or the address where your project is running locally, as shown in the example below:

``` json
  "/apigee-url": {
        "target": "https://gw.api.santanderbr.pre.corp",
        "secure": false,
        "logLevel": "debug",
        "changeOrigin": true,
        "pathRewrite": {
            "^/apigee-url": ""
        },
        "headers": {
            "origin": "http://localhost"
        }
  }
```

> ❗ **Notes**
>
> ***/apigee-url*** and ***/hub-url*** are keys used to create a local [proxy](../../../development-guides/local-environment/proxy.md) to consume APIs during development without encountering ***CORS*** issues.
>
> At the time of application ***deployment***, these keys should be replaced with their respective values according to the [deployment configuration](../../../development-guides/deployment/setup/index.md)
documentation, according to the URLs of each [Apigee environment](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=333840999).
