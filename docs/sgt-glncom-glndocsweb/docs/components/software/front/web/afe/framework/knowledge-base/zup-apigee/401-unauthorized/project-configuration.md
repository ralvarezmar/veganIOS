# Project Setup

## Contextualization

The ***401 unauthorized*** error may be related to the incorrect configuration of the pieces of architecture responsible for promoting coexistence.

To find out if the issue is tied to the implementation, search your project for the HubConnectorInterceptor configuration file.

When you open the file, make sure that the ***urlsToIntercept*** property has the value ***/apigee-url***, as shown in the example below:

``` TS
import { HubConnectorInterceptorConfig } from '@afe/http-interceptors/hub-connector';
export const hubConnectorConfig: HubConnectorInterceptorConfig = {
    urlsToIntercept: [
        '/hub-url',
        '/apigee-url',
    ],
};
```

If it exists, **remove it immediately**! The **HubConnectorInterceptor**, is responsible for managing the update process of ***rolling tokens*** and ***request headers*** only in **ZUP**.

Because of this, any configuration regarding ***apigee*** should only be in the ***@afe/authentication*** configuration file, which is responsible for configuring the project to perform authentication on ***apigee*** and implement coexistence.

Once the correction is made, the ***urlsToIntercept*** property of your file should look like this:

```typescript
import { HubConnectorInterceptorConfig } from '@afe/http-interceptors/hub-connector';

export const hubConnectorConfig: HubConnectorInterceptorConfig = {
    urlsToIntercept: [
        '/hub-url',
    ],
};
```
