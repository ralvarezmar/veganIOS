# Distributed Cache Reference

* Parameters

| Parameter       | Description |
|    :-:          |     :-:     |
| redis-host      | Server address. Default: *localhost* |
| redis-port      | Server port. Default: 6379   |
| redis-pass      | Server password. If the path of a file is informed (eg Secret), the password is read from the file, otherwise it is assumed that the value passed is the password itself. If not informed, it is assumed that the server has security disabled and does not use a password in the connection.  |
| connect-timeout | Connection/reconnection timeout value. It is mainly used when Redis is unavailable, and defines how often the application will try to reconnect. If not informed, it assumes the default value of 10 seconds. |
| default-ttl     | Configures the default TTL (time to live) in seconds that will be used in cache regions that are not declared in the "cache-ttl" parameter below. If not informed, it assumes the default value of 60 seconds.  |
| cache-ttl       | Configure multiple cache regions TTLs (in seconds). |
| use-ssl         | Default value is false, this property must be set to true if you need to use SSL. |
