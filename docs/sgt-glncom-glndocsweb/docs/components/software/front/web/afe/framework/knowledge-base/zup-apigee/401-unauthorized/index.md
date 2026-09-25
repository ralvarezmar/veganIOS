# How to solve ***401 Unauthorized*** in the coexistence between ***Zup*** and ***Apigee***?

## Contextualization

The HTTP client error status code **401 Unauthorized** indicates that the request was not applied because it does not have valid authentication credentials for the target resource.

> The scenarios below were mapped after resolutions of open tickets for the AFE team, so **read them carefully and check if any of them fit the situation of your project.**

Below is a list of scenarios mapped to the **401 Unauthorized status code issue during calls to Apigee:

**Mapped scenarios:**

- [Incorrect version of @afe/http-interceptors](./version-interceptors.md)
- [Project Configuration](./project-configuration.md)
- [Session Time](./session-time.md)
- [Header configuration](./headers-configuration.md)
- [Consumption of coexistence API in v2 using v1 Legacy Token](./legacy-token.md)
