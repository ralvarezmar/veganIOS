# How to Change HTTP Header ***Strict-Transport-Security***

## Contextualization

Strict-Transport-Security (HSTS) is a server-sent security header used to indicate that all future communication between the server and the client should be traversed only by a secure encryption medium (HTTPS).

This way, any insecure (HTTP) requests to this domain will be automatically transformed to HTTPS.

This header helps protect against man-in-the-middle attacks, such as [man in the middle](https://pt.wikipedia.org/wiki/Ataque_man-in-the-middle), by ensuring that all information sent between the server and the client is encrypted.

## Architecture Guidelines

Analyze your application and understand what resources it consumes. HSTS can be configured for both static content, such as images, CSS, JavaScript, and html, as well as dynamic content, such as API requests.

It is recommended that the ***max-age***, which defines the number of seconds during which the browser should remember that a website should only be accessed using HTTPS, has a value of 31536000 seconds (one year).

And also includes the ***includeSubDomains*** flag, ensuring that all subdomains are also accessed only via HTTPS.

### HSTS Configuration for Static Content

To configure the header for static content, add the following directive in the server configuration file 'app.conf':

``` CONF
'location ${NGINX_APP_LOCATION}'
{
    'location ~* ^.+. (?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|woff2|json|svg)$'
    {
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    }
}
```

### HSTS Configuration for Dynamic Content

To configure the header for dynamic content, such as API requests, open a ticket to the [CDG] project team.
