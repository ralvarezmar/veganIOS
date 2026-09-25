# Darwin Composer

### 1. Introduction

The `darwin_composer` is a library designed to orchestrate the implementation of the Darwin Framework into a FastAPI microservice.
It helps the user set up all the pieces of the Darwin Framework and other utilities, packaging them all in a single module.

With `darwin_composer`, the following functionalities are set up:

- Darwin Error Handling
- Darwin Security
- Darwin Logging
- Cross Origin Resource Sharing [(CORS) middleware](https://fastapi.tiangolo.com/tutorial/cors/)
- Internationalization (i18n)
- OpenAPI documentation

It also sets up the following resource:

- Health-check endpoint

### 2. Installation

We can install the library using **pip** or **pipenv**

Pip

```bash
pip install darwin_composer
```

Pipenv

````bash
pipenv install darwin_composer
````

#### 2.1. Test

This library contains the configuration file **pytest.ini** in which we set up everything necessary to run the tests.

#### Without virtual environment

```bash
python -m pytest
```

#### With virtual environment

- Install regular (`Packages`) from Pipfile with command:

```bash
pipenv install
```

- Install Development Dependencies located in Pipfile with command:

```bash
pipenv install --dev
```

**Tip**: The command `pipenv install --dev` could install both regular (`Package`) and development dependencies listed in the Pipfile

- Install Dependencies from setup.py with command:

```bash
pipenv install -e .
```

- To execute the test suite using pytest and validate the implemented tests run the command:

```bash
pipenv run python -m pytest
```

This command will run the entire suite of tests, verifying the functionality and
integrity of the implemented test cases. Ensure that you have the necessary
dependencies and configurations set up before executing the tests.

#### With different python version

The test suite is designed to be compatible with multiple Python versions.
Ensure that you have the required Python version installed before running the tests.
The supported Python versions for this project include 3.9, 3.10, and 3.11.
Verify your Python environment to align with these specified versions for optimal test execution.

- To remove the virtual environment created by Pipenv and associated dependencies, run the command

```bash
pipenv --rm
```

- Specifying Python Interpreter for the virtual environment

To explicitly set the Python interpreter for your project using Pipenv,
use the `--python` flag followed by the path to the desired Python executable. For example:

```bash
pipenv --python c:\location\python-version\python.exe
```

**Tip**: After the python version change, Follow the [Test with virtual environment commands](#21-test)

### 3. Integration into FastApi microservices

In order to use the darwin_composer component, the *darwin_composer* module must be imported and the Fastapi app object passed to it following the form:

```python

# main.py

from fastapi import FastAPI
from darwin_composer.DarwinComposer import DarwinComposer
from some_config_file import config
from routes_directory import routes

app = FastAPI()

Darwincomposer(app, config, routes)
```

#### 3.1. Configuration parameters

The `DarwinComposer` class is initialized with three parameters: *app*, *config* and *routers*.

The *config* object is a dict that allows for customization of the darwin framework.

The *config* object has the following parameters:

| Name                   | Description                                                                   | Type    | Default value     |
|------------------------|-------------------------------------------------------------------------------| ------- | ------------------|
| version                | Version of the microservice. Should be imported from your version.py file.    | {Str}   | "0.0.0"           |
| cors.enable            | Enables/disables cors middleware.                                             | {Bool}  | True              |
| openapi.enable         | Enables/disables custom openapi documentation.                                | {Bool}  | True              |
| openapi.title          | Title of the microservice to show in docs.                                    | {Str}   | "FastAPI Restful Swagger Demo" |
| openapi.description    | Description of the microservice to show in docs.                              | {Str}   | "A Demo for the FastAPI-Restful Swagger Demo" |
| openapi.contact.name   | Name of the author/maintainer of the microservice.                            | {Str}   | "-"               |
| openapi.contact.url    | Contact information url/email.                                                | {Str}   | "-"               |
| i18n.enable            | Enables/disables i18n middleware. It will override configuration made through [environment variables](#4-environment-variables). | {Bool}  | False             |
| i18n.fallback          | Fallback language for internationalization.                                   | {Str}   | "en"              |

Here is an example of a *config* object:

```python

from version import __version__

config = {
     "version": __version__,
     "cors": {
          "enable": False
     },
     "openapi": {
          "enable": True,
          "title": "Some App",
          "description": "It does some cool stuff",
          "contact": {
               "name": "myName",
               "url": "myurl"
          }
     },
     "i18n": {
          "enable": True,
          "fallback": "es-MX"
     }
}
```

#### 3.2 Routing

The `DarwinComposer` class is initialized with three parameters: *app*, *config*, and *routers*.

The *routers* parameter is a list of objects that represent different routes in the microservice.

Each route object has two properties:

- **router**: This is the APIRouter object from the fastapi library that defines the route. It is **required**.
- **tags**: This is an optional list of strings that helps classify the route.

Here is an example of how to define the *routers* parameter in a file:

```python
from fastapi import APIRouter
from darwin_composer.DarwinComposer import RouteClass

router1 = APIRouter()

@router1.get("/endpoint1")
async def endpoint1():
     return {"endpoint": 1}

router2 = APIRouter()

@router2.get("/endpoint2")
async def endpoint2():
     return {"endpoint": 2}

routers = [
     RouteClass(router1, ["endpoint", "other_tag"]),
     RouteClass(router2)
]

```

### 4. Environment variables

This library extends environment variables from the darwin Framework:

| Key                               | Default                                 | Description                         |
|-----------------------------------|-----------------------------------------| ------------------------------------|
| DARWIN_CORE_EXCEPTIONS_ERRROR_FORMAT | `DARWIN` allowed ['DARWIN', 'GLUON'] | {str}: It allows to change the error format |
| DARWIN_SECURITY_PKM_ENDPOINT      | `https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey/` | {str}: The URL of the public key manager |
| DARWIN_SECURITY_JWK_ENDPOINT      |`https://pkm6-sanes-serco1-dev.apps.san01bks.san.dev.bo1.paas.cloudcenter.corp/discovery/v1/keys` | {str}: The URL of the JSON Web Key |
| DARWIN_SECURITY_AUTHENTICATION_TYPE | `pkm`                                 | {str}: Allow to enable PKM or JKU. Possible values `pkm,jku` |
| DARWIN_SECURITY_JWK_ALGORITHMS      |  `['RS256', 'RS384', 'RS512', 'PS256', 'PS384', 'PS512', 'ES256', 'ES256K', 'ES384', 'ES512']`   | {str}: Signature algorithms that are trusted |
| DARWIN_SECURITY_JWK_RSA_REQUEST_TIMEOUT |  `5`                              | {str}: Timeout for JWK and RSA_KEY request in seconds |
| DARWIN_SECURITY_WHITE_LIST        |  `[]`                                   | {str}: Array of URL endpoint  that does not pass through the security check |
| DARWIN_SECURITY_RETRIES           |                  `1`                    | {Num}: Number of tries to connect   |
| DARWIN_SECURITY_CIRCUIT_BREAK_FAILURE_THRESHOLD | `2`                       | {Num}: Numbers of failures before opening the circuit |
| DARWIN_SECURITY_CIRCUIT_BREAK_NAME |           `security_requests`          | {str}: The name of the circuit      |
| DARWIN_SECURITY_CIRCUIT_BREAK_RESET_TIMEOUT| `10`                           | {Num}: Close after this many seconds|
| DARWIN_LOGGING_KAFKA_HOST         | `None` | {str}: Kafka cluster URL listing.  |
| DARWIN_LOGGING_KAFKA_USERNAME     | ----                                    | {str}: Username for Kerberos Authentication. |
| DARWIN_LOGGING_KAFKA_PASSWORD     | ----                                    | {str}: Password for Kerberos Authentication. |
| ENV                               | `DEV`                                   | {str}: Defines the environment (DEV, CERT, TEST, PRE, PRO) for Python applications           |
| LOG_LEVEL                         | `INFO`                                 | {str}: Sets the threshold for the loggers (debug, info, warning, error, critical)            |
| DARWIN_APPKEY                     | `UNSPECIFIED_APPKEY`                    | **Deprecated** {str}: Application Key|
| DARWIN_REGION                     | `UNSPECIFIED_REGION`                    | **Deprecated** {str}: Cluster Region |
| PROJECT_NAME                      | `UNSPECIFIED_PROJECT_NAME`              | {str}: Project name                  |
| APP_NAME                          | `UNSPECIFIED_APP_NAME`                  | **Deprecated** {str}: Cluster application name |
| DARWIN_PYTHON_APPLICATION_VERSION | `UNSPECIFIED_VERSION`                   | **Deprecated** {str}: Python application version |
| DARWIN_LOGGING_KAFKA_HOST_SECURITY_PROTOCOL | `'plaintext'`                  | {str}: Security protocol for Kafka communication |
| DARWIN_LOGGING_KAFKA_PRODUCER_ACK  | `0`                                     | {Num}: The number of acknowledgments the producer requires the leader to have received before considering a request complete. |
| DARWIN_LOGGER_ENTITY              | `ESP`                                   | **Deprecated** {str}: Application Entity |
| DARWIN_CORE_HEADERS_XCLIENTID_COMPATIBILITY    | `True`                     | {bool}: Allow to support x-santander-client-id header |
| DARWIN_LOGGING_FORMAT             | `GLOBAL`                                | {str}: Log format (GLOBAL, GLUON).   |
| DARWIN_LOGGING_KAFKA_UNIQUE_TOPIC | ----                                    | {str}: Enable unique topic for each application. |
| DARWIN_LOGGING_TRANSPORT          | `KAFKA` (if ENV is set) or `CONSOLE` (if ENV is not set)      | {str}: Transport type (KAFKA, CONSOLE). |
| DARWIN_MIDDLEWARES_I18N           | `"False"`                               | {bool}: Allows the internationalization of the microservice |
| DARWIN_MIDDLEWARES_I18N_LOCALES   | `"/etc/i18n/locales"`                   | {str}: The path to the folder languages with json files, and should not be an empty ""  |
