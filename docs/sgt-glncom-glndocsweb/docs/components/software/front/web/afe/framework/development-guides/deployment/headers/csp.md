# How to configure ***CSP*** (***Content Security Policy***)

The CSP (Content Security Policy) is a ***header*** that aims to prevent the user from entering or consuming an external resource from a domain other than the application, being one of the main **mitigation** against **XSS** (Cross-Site Scripting) attacks.

Within the Santander environment, some projects are instructed to configure these ***headers***, under the guidance of the ***EHT*** area.

In order to receive or make requests only for resources that are allocated within the ***santanderbr.pre.corp*** domain and that are consumed by the application. Any other requests should be blocked.

In the example below, right after the comment ***#Content-Security-Policy*** we provide the default policies configured by applications to release resources hosted within the ***santanderbr.pre.corp*** domain.

File: conf.d/app.conf

``` CONF
# Location configuration obtained by environment variable

location ${NGINX_APP_LOCATION} {
    alias /usr/share/nginx/html;
    index index.html index.htm;

    access_log off; # Keep it always in 'off'
    etag on; # Validate the cache based on 'If-None-Match' header
    add_header Expires "-1";
    add_header Cache-Control "public, must-revalidate";
    add_header Pragma "public";

    location ~* ^.+.(?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|woff2|json|svg)$ {
        add_header Expires "-1";
        add_header Cache-Control "public, must-revalidate, no-cache";
        add_header Pragma "public";
        add_header "X-Frame-Options" "DENY";
        add_header "X-XSS-Protection" "1; mode=block";
        add_header "X-Content-Type-Options" "nosniff";
        add_header "X-Download-Options" "noopen";
        add_header "X-Permitted-Cross-Domain-Policies" "master-only";

        # Content-Security-Policy

        set $CSP "default-src 'self' blob: https://*.santanderbr.pre.corp https://*.paas.isbanbr.dev.corp https://*.santanderbr.corp;";
        set $CSP "${CSP} script-src 'self' blob: https://*.santanderbr.pre.corp https://*.santanderbr.corp 'unsafe-inline' 'unsafe-eval';";
        set $CSP "${CSP} style-src 'self' 'unsafe-inline';";
        set $CSP "${CSP} child-src 'self' blob: https://*.santanderbr.pre.corp https://*.santanderbr.corp https://*.santander.com.br https://www.santander.com.br;";
        set $CSP "${CSP} img-src 'self' blob: https://*.santanderbr.pre.corp https://*.santanderbr.corp data:;";
        set $CSP "${CSP} frame-src 'self' blob: https://*.santanderbr.pre.corp https://*.santanderbr.corp https://*.santander.com.br https://www.santander.com.br;";
        set $CSP "${CSP} connect-src 'self' blob: https://*.santanderbr.pre.corp https://*.santanderbr.corp https://*.santander.com.br https://www.santander.com.br https://*.bs.br.bsch/;";
        set $CSP "${CSP} object-src 'self' blob:; media-src 'self' blob:;";
        add_header "Content-Security-Policy" $CSP;
    }
}
```
