# Prerequisites

## HTTPS

In development (***localhost***) we can use SW normally, but to implement it in some environment (make it available on a website) it is necessary to have **HTTPS installed on the server**.

**Reason?** The use of a SW allows you to hijack connections, as well as fabricate and filter responses, as it is a very powerful tool, and this gives a loophole for an unauthorized intermediary to handle the request.

To prevent this from happening, it is only possible to register SW on pages made available on ***HTTPS***, with this, we know that the SW received by the browser was not tampered with during its journey through the network.

## Supported Browsers

Via the website [Is Service Worker Ready?] (<https://jakearchibald.github.io/isserviceworkerready/>), we can check supported browsers, including versions based on desired functionality, as they vary by browser version.

## Configuration

Some Service Workers features are enabled by default in newer versions of supported browsers, but you may encounter a scenario that is not working in the installed version, alternatively, you can configure the option for SW features:

- **Firefox Nightly**: Go to about: ***config*** and change ***dom.serviceWorkers.enabled*** to 'true'; Restart your browser.
- **Chrome Canary**: Go to ***chrome://flags*** and switch to ***experimental-web-platform-features***; Restart your browser (Note that some Chrome features come enabled by default.)
- **Opera**: Go to ***opera://flags*** and enable ***Support for ServiceWorker***; Restart your browser.
- **Microsoft Edge**: Go to ***about:flags*** and check ***Enable service workers***; Restart your browser.
