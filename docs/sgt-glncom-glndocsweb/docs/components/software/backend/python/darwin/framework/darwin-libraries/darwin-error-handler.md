
# Darwin Error Handler

### 1. Introduction

The `darwin_error_handler` is a library designed to centralize the generation and handling of the most common web exceptions, produced by the framework of Darwin Python.

It is characterized by the return of a response in JSON format, specifying the type of error and description if it is available.

The format of the JSON response depends on the configuration.

#### 1.2 Darwin format

```json
{
    "appName": any,
    "timeStamp": any,
    "errorName": any,
    "internalCode": any,
    "shortMessage": any,
    "detailedMessage": any,
    "mapExtendedMessaged": {},
    "status": any
}
```

#### 1.3 Gluon format

```json
{
    "errors":[{
        "code": any,
        "message": any,
        "level": any,
        "description": any
    }]
}
```

> You can enable the different format setting the following environment variable `DARWIN_CORE_EXCEPTIONS_ERRROR_FORMAT`. visit [Environment variables](#environment-variables) for more information.

### 2. Installation

We can install the library using **pip** o **pipenv**

Pip

```bash
pip install darwin_error_handler
```

Pipenv

````bash
pipenv install darwin_error_handler
````

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

???+ Tip

    After the python version change, Follow the [Test with virtual environment commands](#21-test)

### 3. Integration into FastAPI microservices

#### 3.1. Error Handler

In order to use the darwin_error_handler component, the *DarwinErrorHandler* module must be imported and the FastAPI app object passed to it
following the form:

```python

# main.py

from fastapi import FastAPI
from darwin_error_handler.darwin_error_handler import DarwinErrorHandler

app = FastAPI()

DarwinErrorHandler(app) # Integration of the darwinErrorController component

@app.route('/')
def index():
    return "Hello World"
```

When an exception occurs, it will catch the exception and return the following schemas as a response:

Darwin Format

```json
{
   "appName": "-",
    "timeStamp": "-",
    "errorName": "-",
    "internalCode": "-",
    "shortMessage": "-",
    "detailedMessage": "-",
    "mapExtendedMessaged": {},
    "status": int(-1)
}
```

Gluon Format

```json
{
    "errors":[{
        "code": int(-1),
        "description": "-",
        "level": "-",
        "message": "-",
    }]
}
```

#### 3.2. Exceptions

##### Darwin Exception

Most common TPs:

- ***DarwinException***: The `DarwinException` serves as a comprehensive exception handler designed to address unclassified exceptions within our application.
  It encapsulates various forms of error exceptions, ensuring robust error handling and facilitating resilience, flexibility and maintainability.

The `DarwinException` accept 6 types of optional parameters:

- ***error_name*** (str): Error name appropriate for the exception to be handled.

???+ Tip

    It result to the class Exception name raised as default if no value is provided.

- ***status_code*** (str): Status code of the response to return.
- ***internal_code*** (int): Internal code chosen by the user.
- ***short_message*** (any): Brief error message.
- ***detailed_message*** (str): Detailed error message.
- ***map_extended_messaged*** (dict): Custom field in dictionary format.

In order to use the darwin exception, it is necessary to import the *darwin_exception* module and to launch the exception via
a raise statement.

Example 1:

```python

from darwin_error_handler.darwin_exception import DarwinException

def requestFormatIsOk(request):
    if hasattr(request, "headers"):
        pass
    else:
        # Exception without optional parameters
        raise DarwinException()
    if hasattr(request, "payload"):
        pass
    else:
        # Exception with optional parameters
        raise DarwinException(error_name="BadRequestDarwinException", status_code=400, internal_code=-3, short_message="Bad Request", detailed_message="The request must contain the payload attribute", map_extended_messaged={})
```

In the first case for Exception without optional parameters, we will receive the following error response:

Darwin Format

```json
{
    "appName": "PythonTest",
    "timeStamp": "2024-04-22T08:49:53.615479",
    "errorName": "DarwinException",
    "internalCode": -1,
    "shortMessage": "None",
    "detailedMessage": "None",
    "mapExtendedMessaged": {},
    "status": 500
}
```

Gluon Format

```json
{
    "errors":[{
        "code": 500,
        "description": "None",
        "level": "error",
        "message": "2024-04-22T08:49:53.615479-PythonTest-DarwinException-None"
    }]
}
```

In the second case for Exception with optional parameters, we will receive the following error response:

Darwin Format

```json
{
    "appName": "PythonTest",
    "timeStamp": "2024-04-22T08:59:53.823352",
    "errorName": "BadRequestDarwinException",
    "internalCode": -3,
    "shortMessage": "Bad Request",
    "detailedMessage": "The request must contain the payload attribute",
    "mapExtendedMessaged": {},
    "status": 400
}
```

Gluon Format

```json
{
    "errors":[{
        "code": 400,
        "description": "Bad Request",
        "level": "error",
        "message": "2024-04-22T08:59:53.823352-PythonTest-BadRequestDarwinException-The request must contain the payload attribute"
    }]
}
```

???+ Tip

    Any exception raised other than the base `DarwinException` is classified as a generic exception.

Example 2:

**Note**: When encountering potential error conditions, it is recommended to wrap the relevant code in a try-except block and raise a `DarwinException` instead of generic exceptions.

```python
from fastapi import FastAPI
from darwin_error_handler.darwin_exception import DarwinException

app = FastAPI()

@app.get("/")
def index():
    try:
        value = 1 / 0
        return value
    except ZeroDivisionError as exc:
        raise DarwinException(error_name="ZeroDivisionError", status_code=500, internal_code=-3, short_message="ZeroDivisionError", detailed_message=exc.args[0], map_extended_messaged={})
```

In this case of raising a Darwin Exception, we will receive the following error response:

Darwin Format

```json
{
    "appName": "PythonTest",
    "timeStamp": "2024-04-22T08:49:53.615479",
    "errorName": "ZeroDivisionError",
    "internalCode": -3,
    "shortMessage": "ZeroDivisionError",
    "detailedMessage": "division by zero",
    "mapExtendedMessaged": {},
    "status": 500
}
```

Gluon Format

```json
{
    "errors":[{
        "code": 500,
        "description": "ZeroDivisionError",
        "level": "error",
        "message": "2024-04-22T08:49:53.615479-PythonTest-ZeroDivisionError-division by zero"
    }]
}
```

**Note**: Pydantic errors are internally managed by the error handler library as Darwin Exceptions, with the error name designated as ValidationError.

Example:

A scenario where a request endpoint with a POST method requires a JSON body with a field:

```json
{
    "data": ["Test data"]
}
```

If no JSON body is provided in this case, when a Darwin Exception is raised due to a Pydantic error, the error response will be as follows:

Darwin Format

```json
{
    "appName": "pythonfw",
    "timeStamp": "2024-06-21T07:36:46.571784",
    "errorName": "ValidationError",
    "internalCode": -3,
    "shortMessage": "missing",
    "detailedMessage": "Field required",
    "mapExtendedMessaged": {
        "type": "missing",
        "loc": [
            "body"
        ],
        "msg": "Field required",
        "input": null,
        "url": "https://errors.pydantic.dev/2.7/v/missing"
    },
    "status": 422
}
```

##### Generic Exception

A `Generic Exception` refers to any exception raised other than the base `DarwinException`.

Example

```python

def test_function():
    value = 1 / 0
```

This function raises a `ZeroDivisionError`. If this error is not caught and raised as a DarwinException (by wrapping it in a try-except block), it will be considered a generic exception.

In the case of a Generic Exception raising, the following error response will be received:

Darwin Format

```json
{
    "appName": "pythonfw",
    "timeStamp": "2024-06-21T07:19:13.788624",
    "errorName": "ZeroDivisionError",
    "internalCode": -1,
    "shortMessage": "InternalServerError",
    "detailedMessage": "division by zero",
    "mapExtendedMessaged": {},
    "status": 500
}
```

### Environment variables

| Key                               | Default                                 | Description                         |
|-----------------------------------|-----------------------------------------| ------------------------------------|
| DARWIN_CORE_EXCEPTIONS_ERRROR_FORMAT | `DARWIN` allowed ['DARWIN', 'GLUON'] | It allows to change the error format|
