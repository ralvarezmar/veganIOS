# gzip.conf

This file contains the directives in responsible for compressing the responses to requests in order to reduce the bandwidth consumed.

For content that is plain text, Nginx can use gzip compression to deliver these resources back to the client, but compressed.
Modern web browsers will accept gzip compression and this will trim several bytes off each request that comes in the form of plain text resources. The directives used in this file are:

- **gzip**: Compress request responses. By default the policy is enabled.
- **gzip_vary**: Enables or disables the insertion of the response header field if the gzip, gzip_static or gunzip directives are enabled. By default it is enabled.
- **gzip_proxied**: Directive that enables or disables response gzipping for proxy requests depending on the request and the response.
- **gzip_comp_level**: This directive is used to set a gzip compression level of a response. It allows values in the range of 1 to 9.
- **gzip_buffers**: Sets the number and size of buffers used to compress a response.
- **gzip_http_version**: Sets the minimum HTTP version of a request required to compress a response. The default is the minimum version of HTTP 1.1.
- **gzip_types**: Enables response gziping for the specified MIME types. In this case it is enabled on the following types:
  - text/plain
  - text/css
  - application/json
  - application/javascript
  - text/xml
  - application/xml
  - application/xml+rss
  - text/javascript;
