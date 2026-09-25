# How to set up ***app.conf***

The ***NGINX_APP_LOCATION*** variable (discussed in [how to configure environment variables](../setup/variables/replace-tokens.md) is read and processed while reading the ***conf.d/app.conf*** file.

It is responsible for informing the **route** on which the application will be accessed and defining the path on which the server will fetch the main file to access the application (usually the ***index.html***).

File: conf.d/app.conf

``` BASH
location ${NGINX_APP_LOCATION} {
    alias /usr/share/nginx/html;
    index index.html index.htm;
    ...
```

In the **2** line, where the ***alias*** statement is, the following values can be populated:

- **alias**: if the application is accessed by a route other than ***/*** (e.g. ***/reference application***);
- **root**: if the application is accessed from the root ***/***;

> **❗ Information**
>
> If you don't know which category your application is in, use the **configured route** in the **paas** as **reference**.
