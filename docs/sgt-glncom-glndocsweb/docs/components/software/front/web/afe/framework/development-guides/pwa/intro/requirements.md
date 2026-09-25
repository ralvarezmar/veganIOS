# Requirements for a PWA

There are a few requirements that must be met in order for your app to be a "valid" PWA. In principle, it is not necessary to change the current structure of the site to make it work.

What needs to be done is to add a few more files that will be responsible for installing, updating, and offline data.

## Manifest

The main thing is to have the **manifest.json** file properly parameterized at the root of the system. This file contains the application information, such as:

- icon to be displayed when added to the home screen;
- abbreviated name of the application;
- Background color or theme;

> For more information, please refer to our [App manifest.] documentation. (./.. /app-manifest.md)

## ***Service Worker***

The service worker is a JavaScript code component that the browser runs in the background, separate from the web page.

- The Service Worker runs on a separate thread in the browser, so it doesn't have access to the DOM.
- The Service Worker file must always have the same name and always stay in the same place. Otherwise, it will generate a duplicate of the Service Worker.
- The Service Worker file cannot cache, or it may leave an infinite cache on the user's machine. The right thing is inside your server you set the ***max-age*** and put it to always load again, without ***cache***.

> For more information, please refer to our [***Service Worker***](./../service-worker/index.md).

## Certificate ***SSL***

HTTPS is an implementation of the well-known HTTP protocol, with an additional layer of security using the SSL/TLS protocol.

This additional layer allows data to be transmitted over an encrypted connection, and a server and client authenticity check is also done via digital certificates.

Check how to enable SSL on your domain, this is a mandatory rule. It is important to remember to enable the **301** redirect from ***http*** to ***https***, otherwise your application can be accessed through the 2 protocols.

## Responsive & Fast

For an app-like interaction, this is a must-have rule. To include this rule, simply set the correct meta tag for the viewport:

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

> Responsiveness and performance are non-functional requirements of an application, and alignment is necessary within the team so that measures related to them can be taken.

## Cross-Browser

he site must work on multiple browsers (e.g., Chrome, Edge, Firefox, and Safari).

## Deep Linking

Each page of the site must have a unique URL (individual pages are linkable via URL, e.g. to share on social media).
