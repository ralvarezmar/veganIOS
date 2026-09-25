# Web App Manifest on iOS

iOS has some limitations for reading the manifest and turning your project into a web app. Below we will mention some of the solutions found to get around this problem:

## Icons

The icons declared in the ***manifest.json*** do not read correctly and give a bad appearance to the web application icon on the home screen.

This can be circumvented by adding the ***tag*** `<link>` with the 'rel="apple-touch-icon"' within the ***tag*** `<head>` of your application, referencing the appropriate image.

```html
<head>
    <link rel="apple-touch-icon" href="touch-icon-iphone.png">
    <link rel="apple-touch-icon" sizes="152x152" href="touch-icon-ipad.png">
</head>
```

## Startup Screen

The behavior of the splash screen on iOS doesn't work as expected, instead it shows a white screen when launching the web app. To improve this functioning, we can add the 'apple-mobile-web-app-capable' meta tag inside the `<head>` of your app.

```html
<head>
<!-- put it inside the `head` -->
<meta name="apple-mobile-web-app-capable" content="yes" />
    <link href="/apple_splash" sizes="1125x2436" rel="apple-touch-startup-image" />
</head>
```

> See more ways to [make your PWA more native on iOS.](https://medium.com/@oieduardorabelo/pwa-no-ios-como-deix%C3%A1-lo-mais-nativo-e022f6c67b9c)
