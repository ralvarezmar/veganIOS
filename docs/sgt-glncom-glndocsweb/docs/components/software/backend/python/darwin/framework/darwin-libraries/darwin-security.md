# Darwin Security

## Token Verification Component

### 1. Introduction

DarwinSecurity is a Token validation component specially designed to globally protect all
FastAPI-based microservices endpoints. It has a feature that allows you to add to a whitelist those endpoints that can be accessed without a token.
To deal with this we can use a Public Key Manager (PKM) or Authorization Server (JKU).

> You can only use one of the features to validate JWT tokens, PKM or JKU not both at the same time

### 2. Installation

We can install the library using **pip** o **pipenv**
Use the following commands to install the darwin_security package from the command line:

Pip

```bash
pip install darwin_security
```

Pipenv

```bash
pipenv install darwin_security
```

**Note**: The installation of the darwinErrorManager package is necessary for the proper functioning of darwin_security.
Please refer to the following documentation for installation: [darwinErrorHandler](https://github.alm.europe.cloudcenter.corp/sanes-darwin/sanes-darwin-python-error-handler)

#### 2.1. Test

This library contains the configuration file **pytest.ini** in which we set up everything necessary to run the tests.

#### No virtual environment

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

???+ Tip

    The command `pipenv install --dev` could install both regular (`Package`) and development dependencies listed in the Pipfile

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

> After the python version change, Follow the [Test with virtual environment commands](#21-test)

### 3. Configuration and integration into FastAPI microservices

#### 3.1. Configuration

The darwinSecurty security component requires a valid URL where it will query the public key to validate the received token.
Optionally, endpoints that do not require a token to be consulted may also be included in a whitelist.

These arguments are automatically populated when the security component is initially initiated by taking the values from the keys
**DARWIN_SECURITY_PKM_ENDPOINT** and **DARWIN_SECURITY_WHITE_LIST** of the micro-service configuration provided that these are defined, otherwise the component will fail and will not allow the micro-service to be started.

##### 3.1.1. Whitelist

This envinroment variable allow us to exclude an endpoint of the verification security.
The whitelist can contain the following items:

- String: a url string with the exclusion
- Dict: a dictionary that must have two attributes:
  - path: string with url target
  - method: the HTTP method you would like to exclude

> As you can see you can exclude a url with a specific method

##### 3.1.2. Authorization Server (JKU)

It allow us to validate our JWT token using Json Web Key Server. To enable it we must to set the following environment variable

```sh
DARWIN_SECURITY_AUTHENTICATION_TYPE = 'jku'
```

Before import the library we must to set this environment variable, by example:

```python
from fastapi import FastAPI
import os

os.environ['DARWIN_SECURITY_AUTHENTICATION_TYPE'] = 'jku'

""" Import Security module """
from darwin_security.darwin_token_validation import DarwinTokenValidation

"""Creating FastAPI application"""
app = FastAPI(title="FastAPI")
DarwinTokenValidation(app)

@app.get("/")
async def main():
    return {"status": "OK"}

if __name__ == "__main__":
    uvicorn.run("name_fastapi:app")
```

> You must also set the environment variable before importing it.

#### 3.2. Integration into FastAPI microservices

The integration of the darwinSecurty security component into FastAPI microservices is done by importing the DarwinTokenValidation class
And pass the object app by FastAPI

Example:

```python
from fastapi import FastAPI
from src.darwin_token_validation import DarwinTokenValidation #<---- import of the package

app = FastAPI(title="FastAPI")

DarwinTokenValidation(app) # Token verification component initialization
```

To include endpoints within the whitelist it is necessary to include the lower case name of the function or class that defines the endpoint in the micro-service configuration.

Example:

```python
from fastapi import FastAPI
from src.darwin_token_validation import DarwinTokenValidation

app = FastAPI(title="FastAPI")

os.environ("DARWIN_SECURITY_WHITE_LIST") = '["/hello_word"]' #<-- include in the configuration of the microservice the name of the function that defines the endpoint

DarwinTokenValidation(app)

@app.get("/hello_world")
@app.post("/hello_world")
async def main(): #<-- Function defining the endpoint without authorization
    return {"response" : "Hello, World!",
            "method" : "GET/POST"}
```

**Note**:

If you also want to particularize at method level (GET, POST, PUT, etc.), add the method in capital letters preceded by a period.

```python
os.environ("DARWIN_SECURITY_WHITE_LIST") = "[{'path' : '/hello_world' , 'method' : 'GET'}]" #<-- Only THE GET method of the hello_world endpoint would be included
```

You can set an environment variable for example in:

- CMD and CMDR

```cmd
set DARWIN_SECURITY_WHITE_LIST=["/api/v1/example", "/api/v2/example"]
```

- POWERSHELL

```powershell
[Environment]::SetEnvironmentVariable('DARWIN_SECURITY_WHITE_LIST',"['/api/v1/example','/api/v2/example']")
```

```powershell
$Env:DARWIN_SECURITY_WHITE_LIST = "['/api/v1/example','/api/v2/example']"
```

### Environment variables

|          KEY                          |                             DESCRIPTION                                                    |                             DEFAULT                                |
|---------------------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| DARWIN_SECURITY_PKM_ENDPOINT          | The URL of the public key manager                                                          |   `https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey/`      |
| DARWIN_SECURITY_JWK_ENDPOINT            | The URL of the JSON Web Key                      |   `https://pkm6-sanes-serco1-dev.apps.san01bks.san.dev.bo1.paas.cloudcenter.corp/discovery/v1/keys`      |
| DARWIN_SECURITY_AUTHENTICATION_TYPE   | Allow to enable PKM or JKU. Possible values `pkm,jku`                                       |                               `pkm`                                |
| DARWIN_SECURITY_JWK_ALGORITHMS        | Signature algorithms that are trusted                                                      | `['RS256', 'RS384', 'RS512', 'PS256', 'PS384', 'PS512', 'ES256', 'ES256K', 'ES384', 'ES512']`   |
| DARWIN_SECURITY_JWK_RSA_REQUEST_TIMEOUT      | Timeout for JWK and RSA_KEY request in seconds                                                      | `5`   |
| DARWIN_SECURITY_WHITE_LIST     |  Array of URL endpoint  that does not pass through the security check                                                      | `[]`   |

#### Resilience

| Key                               | Default                                 | Description                         |
|-----------------------------------|-----------------------------------------| ------------------------------------|
| DARWIN_SECURITY_RETRIES           |                  `1`                    | Number of tries to connect          |
|DARWIN_SECURITY_CIRCUIT_BREAK_FAILURE_THRESHOLD | `2`                        | Numbers of failures before opening the circuit |
|DARWIN_SECURITY_CIRCUIT_BREAK_NAME |           `security_requests`           | The name of the circuit             |
|DARWIN_SECURITY_CIRCUIT_BREAK_RESET_TIMEOUT| `10`                            | Close after this many seconds       |
