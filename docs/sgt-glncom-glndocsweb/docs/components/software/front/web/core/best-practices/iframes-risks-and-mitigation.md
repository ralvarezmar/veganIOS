# Iframe risks and mitigation

Iframe is a feature available since HTML 4 that allows to embed another webpages, videos or maps in order to display external content inside a webpage. It's possibilities:

* Allow the child web page to use its own cookies
* Auto-play videos
* Display forms
* Change the source site URL
* Trigger alerts
* Run plugins, including the malicious ones
* Allow and execute pop-ups

## Risks

There's a lot of techniques used by attackers to exploit the `iframe` element. Some of them:

* **iFrame Injection**: HTML documents are displayed on websites using iFrames, redirecting users to different websites.
* **iFrame Phishing**: iFrame phishing attacks combine iFrame, which loads a legitimate page, with an iFrame which loads the * attacker’s website to steal data from an unsuspecting user.
* **Cross-Frame Scripting**: The Cross-Frame Scripting (XFS) attack uses malicious JavaScript on an iFrame that loads a legitimate page to collect data.
* **Clickjacking**: A clickjacking assault occurs when a person is persuaded to click a webpage element that is not readily visible.
Therefore, consumers risk unintentionally downloading malware, accessing malicious websites, disclosing passwords or other sensitive information, transferring money, or making online purchases.

With all of these concerns in mind, it's important to understand the involved variables before using iFrames in your site and mitigation techniques to turn your iframe more secure.

## Mitigations

In order to prevent our sites of being vulnerable to iFrame attacks, we can use some techniques to mitigate the risks:

### Use the `sandbox` attribute

The iFrame element's `sandbox` attribute is a helpful security feature for iFrames.
It adds a set of restrictions and prohibits all elements that could pose a security risk, including plugins, forms, scripts, outbound links, cookies, local storage, and access to the same-site page.

By Including `sandbox` attribute with proper configurations in an iframe, it will restrict the actions that the iframe can perform. If there are no values passed to `sandbox`, all restrictions will be applied.

```html
<iframe sandbox="allow-same-origin allow-scripts"></iframe>
```

> Configure `Content-Security-Policy: sandbox` header to be applied for all iFrame in your site. This setup will restrict iFrames loaded in your site to do page actions other than those included in the configurations.
To see more configuration values, check the [iframe MDN documentation](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-sandbox).

### Use the `credentialless` attribute

Iframe `credentialless` attribute give developers a way to load documents in third party iframe using new and ephemeral context.
It's a good option to load untrusted content in your site, once it doesn't provide any access to the network, cookies, and storage data associated with its origin.

```html
<iframe credentialless></iframe>
```

> This is an experimental technology. Check the [credentialless MDN documentation](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-credentialless) for more information.

### Declaring the permission policy by using the `allow` attribute

The `allow` attribute is used to specify a feature policy for the `<iframe>`, in order to explicitly declaring what functionality is used throughout the site.

```html
<iframe src="https://example.com" allow="fullscreen; camera 'none'; microphone 'none'"></iframe>
```

### Use the `srcdoc` attribute

This attribute specifies the HTML content of the page to show in the inline frame. It's expected to be used together with the `sandbox` attribute.

```html
<iframe src="https://target.com.br" srcdoc="<p>This is an paragraph!</p>" sandbox></iframe>
```

> While using `srcdoc` make sure to also include the `src` tag as a fallback.

### Configure `referrer policy`

The referrer policy is how much reference information should be sent with the requests. It provides a set of values to fine-tune the data you share. For example:

* `no-referrer`: Specifies that no reference data is sent with requests.
* `no-referrer-when-downgrade`: It has an initial value. It states that origins without HTTPS will not receive refer headers.
* `origin`: It states that the referrer should always be the document’s origin.
* `origin-when-cross-origin`: When making a same-origin request, it communicates the origin, path, and query string. In all other situations, it merely sends the document’s origin.
* `same-origin`: It states that cross-origin requests will not provide any referrer information, but same-site origins will send the referrer.

### Configure HTTP Content-Security-Policy CSP

Content Security Policy (CSP) is a security standard introduced to prevent cross-site scripting (XSS), clickjacking and other code injection attacks resulting from execution of malicious content in the trusted web page context.

There's some specific directives that can be used to mitigate the risks of using iFrames in your site:

#### [`frame-ancestors`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors)

The configuration of `frame-ancestors` policy allows a shell to restrict what origins can be embedded inside itself. The available options are:

* `deny`: This directive stops the website from being rendered in an iFrame.
* `same-origin:` Allows a page to be rendered in an iFrame if the origin of the iFrame matches that of the page.

> You can also configure `X-Frame-Options` for older browser compatibility.

#### [`frame-src`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-src)

The configuration of `frame-src` policy allows a shell to specify valid sources URLs for external content loading using elements such as `<iframe>.`

## Recommendations

Beyond the iframes, there are other techniques that can be used to embed content in your site:

### Embed with portals

A `<portal>` tag is a proposed HTML element with an independent browsing context, which could improve the page transition experience.
Portals embed content like iframe, but the user cannot access the portal's code. A portal is view-only and cannot be interacted with by users.

Portals offer the low complexity of a multi-page application with the seamless transitions of a single-page application. These transitions can be animated, quickly replacing the content in the browser window.

> To know more about portals, check the [portal tutorial](https://web.dev/hands-on-portals/).

```html
<portal id="example" src="https://example.com/"></portal>
```

### Embed with fenced frames

A fenced frame `<fencedframe>` tag is a proposed HTML element for embedded content, similar to an iframe.
Unlike an iframe, a fenced frame restricts communication with its embedding context to allow the frame access to cross-site data without sharing it with the embedding context.
Similarly, first-party data on the parent's page cannot be shared with the fenced frame.

```html
<fencedframe src="https://3rd.party.example"></fencedframe>
```

## Conclusion

By applying all the mitigation techniques described in this document, mainly [CSP Configuration](#configure-http-content-security-policy-csp) and the iframe's attributes you can prevent your site of being vulnerable to [attacks](#risks),
even with you are loading third party content in your site.
