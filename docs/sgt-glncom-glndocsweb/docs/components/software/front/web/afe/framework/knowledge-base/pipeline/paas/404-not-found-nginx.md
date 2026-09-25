# How to troubleshoot "404 Not found" in nginx

## Contextualization

The **404 not found** error when trying to access a sub-route of an application happens because the server has not been configured correctly to redirect the requests.

## Solution

Within this scenario, there are two possibilities:

Enable ***useHash*** in the routes module:

```typescript
    RouterModule.forRoot(routes, {
        useHash: true
    }),
```

With this, the URL will be accessed in '<https://url.com.br/#/sub-rota>'

Change the app.conf file by adding the following lines:

```conf
location ${NGINX_APP_LOCATION} {
    try_files $uri $uri/ /index.html =404;
    location ~* ^.+.(?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|woff2|json|svg)$ {
        try_files $uri =404; # ADICIONAR ESSA LINHA
        }
    }
```

This way, the URL will be '<https://url.com.br/sub-rota>'
