# Header sanitization

__Processing cost:__ Depending on the size and amount of trafficked headers, it
can impact the application's performance.

__Possible size limitation:__ Although the http specification does not limit the
maximum size of headers, some technologies may limit the number of characters
of HTTP headers by default (References suggest HTTP error 431 for this
scenario), unnecessary headers traffic can generate errors due to
this limitation.

__Vulnerabilities:__ Propagation of some headers to the client can generate
vulnerabilities in the application. Some examples in our Bank scenario:

* x-forwarded-for: This header is a list of all layers where the request passed.
  If it is "echoed" in the response of the Camel call, the client will receive
  information from internal hosts and IPs of the bank, which is considered a
  vulnerability.
* x-encrypted-object: This is a header used internally in Camel, it is the key
  to do the decrypt and encrypt combined with the key exchange done on the
  client side. By returning it in the response, you will be exposing the
  encryption key that should only be known by the backend.

## How to remove headers in Camel?

__removeHeader:__ Removes a header by name

```{.java .copy}
from("seda:b")
  .removeHeader("myHeader")
  .to("mock:result");
```

!!! tip "Attention!"

    __Note:__ The "from" and the "to" are just to illustrate
      the positioning of the function within a flow

    __removeHeaders:__ Removes one or more headers from a given pattern

Removing all headers

```{.java .copy}
from("seda:b")
  .removeHeaders("*")
  .to("mock:result");
```

Removing all Camel headers

```{.java .copy}
from("silk:b")
   .removeHeaders("Camel*")
   .to("mock:result");
```

!!! tip "Attention!"

    __Note:__ The "from" and the "to" are just to illustrate
        the positioning of the function within a flow
