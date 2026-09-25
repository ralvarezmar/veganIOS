# Incorrect version of ***@afe/http-interceptors***

## Contextualization

The ***401 unauthorized*** error with the ***invalid token*** message when performing the **key exchange** may be related to the versions of the installed architecture parts that are not prepared to handle coexistence.

## Solution

To validate this point, open ***package.json*** and verify that the following versions of the architecture parts are installed:

If your project uses ***@afe/http-interceptors*** on version ***1.x***, check if version **1.5.0** or higher is being installed, according to the example below:

```json
"@afe/http-interceptors": "^1.5.0"
// ou
"@afe/http-interceptors": "1.5.0"
```

If your project uses ***@afe/http-interceptors*** on version ***2.x***, check if version **2.1.1** or higher is being installed, according to the example below:

```json
"@afe/http-interceptors": "^2.1.1"
// ou
"@afe/http-interceptors": "2.1.1"
```

And if your project makes use of ***@afe/generalbase***, make sure that version **1.5.0** or higher is being installed, according to the example below:

```json
"@afe/base-geral": "^1.5.0"
// ou
"@afe/base-geral": "1.5.0"
```
