# Getting the GTM (Google Tag Manager) code

To obtain the GTM code, you need to contact the [Tagging team](https://confluence.santanderbr.corp/display/TAGSBR/2.+Tagueamento) to provide a code that must be entered in the ***index.html*** of your application.

## GTM (Google Tag Manager) Configuration

Once you have acquired the code, import into your application's ***index.html*** the ***script*** below inside the `<head>` tag, replacing **GTM-XXXXXX** with the tag manager code.

``` HTML
<!-- index.html -->

<html lang="pt-br">
<head>
  <!-- hidden code -->

  <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-XXXXXX');</script>
    <!-- End Google Tag Manager -->
</head>
<body>
  <app-root></app-root>
</body>
</html>
```

## Content Security Policy (CSP) Configuration

**Content Security Policy** is a header that aims to prevent the user from entering an external ***resource*** from a domain other than the application domain, preventing [XSS](https://owasp.org/www-community/attacks/xss/) attacks.

In order for us to import the ***script*** from **Google Tag Manager** without running into this policy, we need to perform the following configuration:

Add the addresses that are requested by GTM in the existing CSP headers in the ***conf.d/app.conf*** file:

Url       | Resource
--------- | ------------
***<https://www.google-analytics.com>***, ***<https://www.google.com>***, ***<https://www.google.com.br>***, ***<https://stats.g.double-click.net>***, ***\*.analytics.google.com***, ***\*.google-analytics.com*** | **img-src**
***<https://www.google-analytics.com>***, ***<https://www.googletagmanager.com>*** | **script-src**

The example below must be added to the headers already configured in your ***app.conf***.

``` BASH
# conf.d/app.conf

# Configuração do location obtida por variável de ambiente
location ${NGINX_APP_LOCATION} {
    # Código omitido

    location ~* ^.+.(?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|woff2|json|svg)$ {
        # Código omitido
        add_header "X-Content-Security-Policy" "script-src 'self' blob: https://www.google-analytics.com https://www.googletagmanager.com; img-src 'self' blob: https://www.google.com https://www.google.com.br https://www.google-analytics.com https://stats.g.double-click.net *.analytics.google.com *.google-analytics.com data:;";
        add_header "Content-Security-Policy" "script-src 'self' blob: https://www.google-analytics.com https://www.googletagmanager.com 'unsafe-inline' 'unsafe-eval'; img-src 'self' blob: https://www.google.com https://www.google.com.br https://www.google-analytics.com https://stats.g.double-click.net *.analytics.google.com *.google-analytics.com data:;";
    }
}
```
