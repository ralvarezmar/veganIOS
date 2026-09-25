# How to set up ***headers*** for coexistence between ***zup*** and ***apigee***

We know that it is possible to implement the coexistence between ***zup*** and ***apigee*** locally using the [proxy configuration](../../local-environment/proxy.md), but when we **deploy** our application in the development, homologation and PRD environments.

It is necessary to [open a ticket to the CDG](https://jira.santanderbr.corp/projects/SCDGHUBBR/), requesting the configuration of the following ***headers***:

| Header | Description |
| ------ | --------- |
| **[***Access-Control-Expose-Headers***](https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Headers/Access-Control-Expose-Headers)** | Responsible for exposing the headers that will be consumed by the application. The following ***headers***: ***x-uid***, ***x-access-token***, ***x-apigee-access-token*** and ***x-access-token-expiry***, should be requested. |
| **[***Access-Control-Allow-Headers***](https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Headers/Access-Control-Allow-Headers)** | Responsible for indicating which ***headers*** can be used during the request made. By default, when requesting the release of this ***header*** the ***default*** value is **\*** (i.e. all ***headers*** are released) |
| **[***Access-Control-Allow-Origin***](https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Headers/Access-Control-Allow-Origin)** | Responsible for indicating whether the resources of the response can be shared with the indicated ***origin***. By default, it picks the source of the request that was made (usually the ***url*** of the application itself) |
