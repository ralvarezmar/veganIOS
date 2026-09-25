# Common-headers.conf

In this file you will find the common configuration of the add_headder directive.

## Directives

### **add_header**

The add_header directive allows you to define an arbitrary response header and value to be included in all response codes, which are equal to `200`, `201`, `204`, `206`, `301`, `302`, `303`, `304`, or `307`.

``` TEXT
add_header Custom-Header Value;
```

The `Custom-Header` portion corresponds to the name of your response header while the Value portion corresponds to what value you want the header to return. This directive can be defined either in an HTTP, server, or location block.

Parameters such as those shown below has been added to this directive in the archetype:

#### Content-Security-Policy

This parameter together with the `add_header` directive is used to restrict the accepted origin of the content. By default, our configuration only accepts content from our own sources (`default-src 'self'`).
If you want to access external sources you must change the configuration of this parameter.
This directive is quite restrictive so you have to be careful when configuring it because if you do not indicate all the static paths to which you want to access the application will not work.

This parameter can be overwritten with the environment variable `CSP_RULE`. If this environment variable is not set, then the default value for the header will be:

``` TEXT
"default-src 'self'; font-src 'self'; img-src 'self' data:; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
```

The main purpose of this header is to help improve the security of our website. As explained above with this directive we specify what origin each type of resource served on our page can have.
The types of resources that can be loaded are: `default-src` (default), `img-src` (images), `font-src` (fonts), `style-src` (styles), `script-src` (scripts), ...

It is necessary to specify the possible origin of the resources, if so, this directive takes precedence over `default-src`. For example, if we put a font-src directive, the origin of such resources will be the one specified and not `default-src`.
However, as nothing has been specified about the `img-src` directive, `default-src` will be applied generically for web images.

To help you configure this policy you can use this plugin for firefox [Laboratory (Content Security Policy / CSP Toolkit) – Get this Extension for 🦊 Firefox (en-US)](https://addons.mozilla.org/en-US/firefox/addon/laboratory-by-mozilla/).

It is in responsible of compiling all the static routes that we load in our web to add them to a whitelist, then it is simply to keep the list of dns and apply them to the policy.

Other resources of interest that will help us when configuring CSP is [cspvalidator.org](https://cspvalidator.org/) or [securityheaders.com](https://securityheaders.com/) that allows us to check the CSP headers of a web site.

For more information about Content Security Policy go to the following link: [Content-Security-Policy (CSP) Header Quick Reference](https://content-security-policy.com/).

#### Referrer-Policy

The idea is that when you arrive at a site (destination), through a link on our page (origin),
the browser sends an HTTP header to the destination server that is identified as "Referrer" and where you can find the absolute or relative address of the origin where the link was that took you to the place where the browser is now.

- `no-referrer` value will omit the _Referer_ header. Sent requests do not include any referrer information.

#### X-XSS-Protection

The X-XSS-Protection header allows you to force browsers to apply their XSS protection even if the option has been disabled by the user.
Thus, if the following header is present in an HTTP response, the browser will be forced to enable its anti-XSS protection and block responses that have been modified to contain scripting code.

- `1; mode=block` Enables XSS filtering. Rather than sanitizing the page, the browser will prevent rendering of the page if an attack is detected.

#### X-Content-Type-Options

Although HTTP responses include a header that specifies to browsers the type of content they are receiving (Content-Type),
most browsers use a technique called MIME sniffing that consists of automatically identifying the content instead of relying on the header received by the server.

- `nosniff`. The browsers that support this header (IE and Chrome), do not load the stylesheets, nor the scripts (Javascript), whose MIME-type is not the appropriate.

#### Cache-Control

Header specifying instructions for caching both requests and responses.
It is accompanied by the following configuration parameters:

- `no-cache`. Indicates that the response can be stored in caches, but must be validated with the origin server before each reuse, even when the cache is disconnected from the origin server.
- `no-store`.  Indicates that any caches of any kind (private or shared) should not store this response.

#### Permissions-Policy

Header provides a mechanism to allow and deny the use of browser features in its own frame, and in content within any `<iframe>` elements in the document.
It is accompanied by the following configuration parameters:

- `geolocation`. Controls whether the current document is allowed to use the [Geolocation](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation)
Interface. When this policy is disabled, calls to [getCurrentPosition()](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/getCurrentPosition) and
[watchPosition()](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/watchPosition) will cause those functions' callbacks to be invoked with a
[GeolocationPositionError](https://developer.mozilla.org/en-US/docs/Web/API/GeolocationPositionError) code of `PERMISSION_DENIED`.
- `microphone`. Controls whether the current document is allowed to use audio input devices. When this policy is disabled, the [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) returned by
[MediaDevices.getUserMedia()](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia) will reject with a [NotAllowedError](https://developer.mozilla.org/en-US/docs/Web/API/DOMException#exception-notallowederror).
- `camera`. Controls whether the current document is allowed to use video input devices. When this policy is disabled, the [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) returned by
[getUserMedia()](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia) will reject with a [NotAllowedError](https://developer.mozilla.org/en-US/docs/Web/API/DOMException#exception-notallowederror) [DOMException](https://developer.mozilla.org/en-US/docs/Web/API/DOMException).

#### Pragma

Is an implementation-specific header that may have various effects along the request-response chain.
Use the following value:

- `no-cache`. Forces caches to submit the request to the origin server for validation before a cached copy is released.

#### Strict-Transport-Security

This header forces clients to communicate with the server only via the HTTPS protocol, i.e. it forces the use of encryption to protect communications.

It is accompanied by the following configuration parameters:

- `max-age=<expire-time>`. This is the time, in seconds, that the browser must remember that the site should only be accessible using HTTPS.
- `includeSubDomains` (optional). If this optional parameter is specified, the rule applies to all subdomains of the site.

It should be noted that certain browsers such as Chrome, Firefox or Safari include a list of domains that have specified that they should only be accessed via HTTPS, this prevents these domains from being accessed under HTTP,
also eliminating the possibility of a man-in-the-middle (MitM) attack.

#### X-Frame-Options

This response header can be used to indicate whether a browser should be allowed to render a page in a `<frame>`, `<iframe>`, `<embed>` or `<object>`.
Sites can use this to avoid click-jacking attacks by ensuring that their content is not embedded on other sites. The added security is provided only if the user accessing the document is using a browser that supports X-Frame-Options.
Use the following value:

- `SAMEORIGIN`. The page can only be displayed in a frame on the same origin as the page itself.

#### X-UA-Compatible

- `IE=Edge`. It is used for web page compatibility with browsers such as Internet Explorer and Edge.
