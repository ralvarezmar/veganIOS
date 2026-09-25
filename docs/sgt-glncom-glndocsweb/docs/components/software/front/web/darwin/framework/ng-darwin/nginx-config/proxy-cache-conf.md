# proxy-cache.conf

In this file you will find the configuration of the directives in responsibility of the proxy and cache configuration. The directives used in this file are:

- **add_header X-Config-Overridden true;**: Header that tells you that the configuration, config.json, has been successfully obtained when the call to the configuration service is made.
This header is a help for the developer to know that everything has gone correctly.
- **proxy_set_header Authorization**: Allows you to redefine or add fields to the request header passed to the proxy server. In this case it is passing the TOKEN.
- **proxy_ignore_headers**: Disables the processing of specific response header fields from the proxy server, in our case it allows to ignore the max-age value in the Cache-Control header and to apply the value in proxy_cache_valid.
- **proxy_cache**: Defines a shared memory area used for caching. The same zone can be used in several places.
- **proxy_cache_bypass**: Defines the conditions under which the response will not be taken from a cache. If at least one value of the string parameters is not empty and not equal to "0", the response will not be taken from the cache.
- **proxy_cache_lock**: When this policy is enabled, if there are parallel requests to a proxy server, only one of these requests is allowed to fill a new cache item.
The other requests for the same cache item will wait for a cache response or cache lock to appear before the item is released, up to the set time.
- **proxy_cache_valid**: Sets the caching time for different response codes.
- **proxy_cache_use_stale**: It determines in which cases an obsolete cached response can be used during communication with the proxy server. In our case it will be when the following errors appear:
  - error
  - timeout
  - invalid_header
  - updating
  - http_500
  - http_502
  - http_503
  - http_504
  - http_403
  - http 404
