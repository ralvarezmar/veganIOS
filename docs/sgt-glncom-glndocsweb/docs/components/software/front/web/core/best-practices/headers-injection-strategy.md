# Headers injection strategy

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=e4ecb843-6615-407b-ac87-2902f603b0a3" width="840" height="560" frameborder="0" scrolling="no" allowfullscreen title="injection-flow.png"></iframe>

`HttpHeadersModule` from `@santander/http-angular` provides features related to the http headers injection logic.
This logic is based on the specification of certain headers that will be applied to certain url, among other details.
This page aims to explain how this feature can be understood and used.  

## Configuration and typing

In order to use the feature, the first step is to provide the configuration to the `HttpHeadersModule`. It can be provided with the usage of the methods `forSPA` and `forMFE` available among the configuration resolution.

### Configuration Interface

```ts
export type HeaderConfig = {
  url: string | RegExp;
  headers: Headers;
  target?: 'shell' | 'mfe' | 'all';
  mode?: 'no-override' | 'override';
};
```

| Parameter                            | Description                                                                                                                                                                                                                    |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `url`: `string | RegExp`             | The url that, when consumed, it should apply the headers. This url will be dynamic in the terms of matching the url. Will be explained further.                                                                                |
| `headers`: `Headers`                 | Native typescript headers. When defined in the json files, it will appear as a key-value object.                                                                                                                               |
| `target`: `'shell' | 'mfe' | 'all'`  | Optional. Exclusive for SPAs. This property will define the application that will be affected by this item. If not defined, it will have the value of the current application. EX: In `Shell`, it will have the value `Shell` |
| `mode`: `'no-override' | 'override'` | Optional. Default value `'no-override'`. It defines the logic to follow when applying the headers. If it's set as `'override'` it will override the previous header value if present and inject the configured ones.          |

### How the configuration is provided

In order to provide the configuration, the methods `forSPA` and `forMFE` available from the `HttpHeadersModule` must be used. Importing this module in the application module would look like this:

#### Configuration for SPAs and Shell

The `HttpHeadersModule` provides the method `forSPA`. This method should be used for both SPAs and Shells due that it will work the same way.

``` ts
export const appConfig: ApplicationConfig = {
  providers: [
    // ...existing providers...
    importProvidersFrom(
      HttpHeadersModule.forSPA({
        useFactory: acquireHeadersConfig,
        deps: [ConfigService]
      })
    )
  ]
};
```

#### Configuration for MFE

``` ts
export const appConfig: ApplicationConfig = {
  providers: [
    // ...existing providers...
    importProvidersFrom(
      HttpHeadersModule.forMFE({
        useFactory: acquireHeadersConfig,
        deps: [ConfigService]
      })
    )
  ]
};
```

In the `useFactory` a method that retrieves the configuration should be used.

``` ts
export async function acquireHeadersConfig(configService: ConfigService): Promise<any> {
  const cfg: any = await firstValueFrom(configService.onConfigLoaded$ as Observable<AppProps>);
  const httpConfiguration = cfg.gluon.http;
  return Promise.resolve(httpConfiguration);
}
```

## Usage explanation

### How to match Urls

Before defining anything else, the most important part of the configuration is the strategy used to match the url.
For the property `url`, both a `string` and a `RegEx` can be used.

#### RegEx

When using `RegEx`, is as simple as providing a regular expression that will match the url that the headers should be injected. For example:

The following RegEx, `https://(.+).example.com`, would be able to match `https://sub.example.com`. If the match occurs, then the header configuration is taken into consideration.

#### Strings

Strings can be used for matching urls, but, it can be more complex than just providing the exact url like `https://sub.example.com`.

For matching urls, the **URL Pattern API** is used. This is a standardized syntax used to create URL pattern matchers.

For example, the following configuration:

``` json
{
 "url": "*://*/api/logger/logs",
 "headers": {
  "x-header-first": "1",
  "x-header-second": "2",
 }
}
```

Would be able to match the url no matter what protocol or domain uses, urls as `'https://example.com/api/logger/logs'` and `'https://anotherexample.com/api/users'` would match and apply the headers configured.

In order to understand the full capability of this **URL Pattern API** and how it works, you can visit [URL Pattern API MDN](https://developer.mozilla.org/en-US/docs/Web/API/URL_Pattern_API), where every aspect is explained.

### How to define the headers

Once the url has matched, the headers will be tried to be applied. These headers should be configured as a key-value pairs.
As portrayed in the previous example, these headers should be configured inside the items that contains the url, meaning, when that url matches, every single header should try to be applied.

``` json
{
 "url": "*://*/api/logger/logs",
 "headers": {
  "x-header-first": "1",
  "x-header-second": "2",
 }
}
```

### How to specify the target

This feature, is used to specify when the headers should be apply depending on the origin and runtime of the request. To understand this, some scenarios can be imagined:

* A MFE does a request, it has some headers configuration, does not need to specify any target because it's request origin it's himself and it's being executed there.
* A Shell does a request, applies the same as the MFE.
* A Shell **receives** a request coming from one of its MFEs, and then it has to execute it.

In that third case, where the application can execute request that were no created within itself, it's where this features shines.

`Target` allows the following values:

* `Undefined`. Then it will apply only for request with origin within the `Shell`.
* `Shell`. Same as the previous one.
* `MFE`. When target is MFE, and the request in the Shell being executed, it's origin it's from one of the children `MFEs`. When `MFE` target is set, then the headers will only apply in this case explained.
* `All`. When `All` target is set, does not matter if the previous case where the request's origin was a `MFE`, or it's the `Shell` itself, that the configuration will try to apply.

### How to configure the overriding logic

By default, the injection of headers applies the following statement:

**The headers injection will respect the values already defined in the request, meaning that it will not override those headers with the configured ones in the module.**

Meaning that, if the following request is executed:

``` ts
this._httpClient.get('http://localhost:3001/api/logger/logs', {headers:{channel:'10'}}).subscribe();
```

But, the configuration looks like:

```json
{
 "url": "*://*/api/logger/logs",
 "headers": {
  "channel": "200"
 }
}
```

When the request is finally executed and handled to the destination, the header `channel` **will keep the value 10**.

Here is where the property `mode` play its role. If that same configuration, is defined with the `mode: 'override'`:

```json
{
 "url": "*://*/api/logger/logs",
 "headers": {
  "channel": "200"
 },
 "mode": "override"
}
```

Then, when the request has been processed and handled to its destination, the header `channel` **has overridden the previous value and now, it's 200**.

### How the order matters

In the previous section, the overriding logic has been seen, but, there is a special consideration that it has to be kept in mind when defining the configuration:

**Once a header value has been inyected, it prevails until it gets overided from a `mode: 'override'`**.

This means that, when defining the configuration, if they matches the same url, and tries to apply multiple headers like:

```json
{
 "url": "*://*/api/logger/logs",
 "headers": {
  "channel": "200"
 }
},
{
 "url": "*://*/api/logger/logs",
 "headers": {
  "channel": "400"
 }
}
```

And this request that **does not have** the channel header already is executed:

```ts
this._httpClient.get('http://localhost:3001/api/logger/logs').subscribe();
```

The headers are applied **from top to bottom**, meaning that, first the `channel 200` will be applied, and then, when it matches again and tries to apply `channel 400` , it will not be possible. **It will keep the channel 200 as final value**.

This unless it finds later another matching url that has the `mode: 'override'`. Then **it would get override to the new value**.

!!! note
    The order and the mode will not considerate where the request it's from, besides the `target` functionality, all other properties works as defined.

## Use cases

### Shell wants to apply headers for theirself

#### Configuration used

```json
{
 ...
 "http": [
  {
    "url": "*://*/api/logger/logs",
    "headers": {
      "channel": "200",
      "x-santander-security": "gluon"
    },
  },
  {
    "url": "*://*/api/users/*",
    "headers": {
      "channel": "100",
      "x-santander-security": "darwin"
    },
  }
 ]
}
```

With the request:

```ts
this._httpClient.get('http://localhost:3001/api/logger/logs',
{headers: {"channel": "50"}}).subscribe();
```

#### Result

The url will match with the first one and will respect the `channel 50` and apply `x-santander-security: gluon`

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=7ea2b684-02b7-4901-88c8-867d949a20cb" width="840" height="560" frameborder="0" scrolling="no" allowfullscreen title="result1.png"></iframe>

### Shell wants distinct headers for itself and for the children MFE

#### Configuration used

```json
{
 ...
 "http": [
  {
    "url": "*://*/api/logger/logs",
    "headers": {
      "channel": "200"
    },
  },
  {
    "url": "*://*/api/logger/logs",
    "target": "mfe",
    "headers": {
      "x-santander-security": "gluon"
    }
  },
 ]
}
```

With:

* First: **COMING FROM A MFE:**

```ts
this._httpClient.get('http://localhost:3001/api/logger/logs').subscribe();
```

* Second: **COMING FROM THE SHELL ITSELF:**

```ts
this._httpClient.get('http://localhost:3001/api/logger/logs').subscribe();
```

#### Result

For the first request, only the `x-santander-security` header will be applied.

For the second request, only the `channel` header will be applied. *(Specifying `target: shell` and keeping it undefined means the same).*

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=6d2acd0c-add9-4120-b9ad-f0fbe3ebefb8" width="840" height="560" frameborder="0" scrolling="no" allowfullscreen title="result2.png"></iframe>

### Shell wants to make sure the headers are apply to its MFEs no matter what

#### Configuration used

```json
{
 ...
 "http": [
  {
    "url": "*://*/api/logger/logs",
    "headers": {
      "channel": "200"
    },
  },
  {
    "url": "*://*/api/*",
    "target": "mfe",
    "mode": "override",
    "headers": {
      "x-santander-security": "gluon",
      "channel": "300"
    },
  },
 ]
}
```

With:

* First: **COMING FROM A MFE**:

```ts
const headers = {
 "x-santander-security": "darwin",
 "channel": "0"
}
this._httpClient.get('http://localhost:3001/api/logger/logs',
{headers: new HttpHeaders(header)}).subscribe();
```

* Second: **COMING FROM THE SHELL ITSELF:**

```ts
this._httpClient.get('http://localhost:3001/api/logger/logs').subscribe();
```

#### Result

For the first request, **even that the request had already the headers present, they will be override to:**

`x-santander-security: darwin`  => `x-santander-security: gluon`

`channel: 0`  => `channel: 300`

For the second request, it will just apply header `channel 200`.

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=d2cf0f3d-b4b7-40c7-8c0d-0a34de17b0ac" width="840" height="560" frameborder="0" scrolling="no" allowfullscreen title="result3.png"></iframe>
