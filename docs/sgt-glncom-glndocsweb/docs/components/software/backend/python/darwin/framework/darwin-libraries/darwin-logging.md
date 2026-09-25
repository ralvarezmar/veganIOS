# Darwin Logger

## Darwin traceability and logging component

### 1. Introduction

DarwinLogging is a traceability and logging component specially designed to monitor requests
incoming and outgoing from a micro-service and to manage technical and activity logs through the platform
Kafka distributed event transmission.

The DarwinLogging component is designed to integrate with any Fastapi microservice. However, it can
be integrated into any python application by automatically disabling traceability and activity logs.

The Tracer component is designed to propagate the common headers, security and traceability, to this end, it performs a proxy on the outgoing HTTPs AND HTTPs requests.

???+ Tip

    By default the SSL communication is enabled in productive environments(Develop, Pre-production, Production).

### 2. Installation

We can install the library using either **pip** or **pipenv**

Pip

```bash
pip install darwin_logging
```

Pipenv

````bash
pipenv install darwin_logging
````

#### 2.1. Test

This library contains the configuration file **pytest.ini** in which we set up everything necessary to run the tests.

No virtual environment

````bash
python -m pytest
````

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

### 3. Integration into FastApi microservices and General Applications

#### 3.1. Integration into FastApi microservices

##### a) Logs

In order to use the darwinLogging component, the *darwin_logging* module must be imported and the FastAPI app object passed to it following form:

````python
from fastapi import FastAPI # main.py
"""Importing Logging component"""
from darwin_logging.DarwinLogs import DarwinLogs

"""Creating FastAPI application"""
app = FastAPI(title=__name__)

"""Initializing logging component"""
DarwinLogs(app) # the application object of FastAPI is introduced by the component.

"""Printing logs"""
app.logger.info("This function is amazing")
app.logger.debug("This function is amazing")
app.logger.error("This function is amazing")
app.logger.info({'dict': True, 'number_test': 1})
app.logger.debug({'dict': True, 'number_test': 1})
app.logger.error({'dict': True, 'number_test': 1})
````

> In order to print debug traces you must to set the environment variable **LOG_LEVEL** to *debug* value

##### b) Propagation Headers

This piece is in charge of propagating headers in outgoing requests. This piece creates or propagate the B3 and W3C headers
By default, we propagate the following headers.

- Common
- Security
- Observability

We propagate the following headers by default:

| Header Name            | Header type   |
| ---------------------- | ------------- |
| organization           | common        |
| accept-language        | common        |
| x-clientid             | common        |
| x-santander-thirdparty | common        |
| x-santander-device     | common        |
| x-santander-channel    | common        |
| x-santander-entity     | common        |
| mode                   | common        |
| authorization          | security      |
| user-agent             | observability |
| contact-point          | observability |
| session-id             | observability |
| app-init               | observability |
| x-b3-traceid           | tracing (B3)  |
| x-b3-spanid            | tracing (B3)  |
| x-b3-parentspanid      | tracing (B3)  |
| x-b3-sampled           | tracing (B3)  |
| b3                     | tracing (B3)  |
| traceparent            | tracing (W3C) |
| tracestate             | tracing (W3C) |

???+ Tip

    For more information about B3 headers, [visit this web](https://github.com/openzipkin/b3-propagation)

???+ Tip

    For more information about W3C headers, [visit this web](https://www.w3.org/TR/trace-context/)

##### c) Traceability

The traceability component automatically processes the entry request heads and stores them in a form
temporary while the request is active and at the end it returns them to the response heads in case of any of them
it would have been amended.

For exit requests from the microservice it is necessary to use a handler which automatically grazes the heads
to be propagated.

In order to make any request to exit from the microservice, the module request_handler of the following must be imported

Example:

````python
from darwin_logging import make_request # request_frommicro.py

def callingOtherMicro():
  url = "http://example.com"
  headers = { "my_header": "hello_world" }

  response = make_request(method = 'GET', url = url, headers = headers) # example of GET

  response = make_request(method = 'POST', json = { "data": "data" }, url = url, headers = headers) # example of POST

  return response
````

#### 3.2. Integration into General Applications

Since the traceability component and activity logs are disabled for use in any python application that isn't a micro-service, it is only possible to use the technical log.

To use the logger component follow the following steps:

1. Import the logger component.
2. Seed the component, either in the application main or in the application main class builder.
3. Create a logger without arguments with the *getlogger* command of the logging library.
4. Logging using the created logger.
5. Create a logger without arguments for each module.

```python
import os
os.environ['DARWIN_APPKEY'] = 'pythonfw'
os.environ['APP_TYPE'] = "NO_MICRO"
"""Importing Logging component"""
from darwin_logging.DarwinLogs import DarwinLogs #<------- 1.
import logging

logger = logging.getLogger() #<------- 3.
darwinLogs = DarwinLogs()

logger.info('Hello world') #<------- 4
```

> With this lines we have already configured the library.

To use it into another module you just only need to import it.

```python

import logging # othermodule.py

logger = logging.getLogger() #<------ 5.

def hello_world_fn():
    logger.info("IN HELLO WORLD FUNCTION")
```

##### a) Traceability

This feature allow us to generate traceability in our Python scripts. Using a context we can share the generated headers between modules.
To generate a Traceability context we just to use our Otel Class.

```python
from darwin_logging.tools.otel import Otel
otel = Otel()
some_header_parent_context = {} # This dict can be used to create a context using a parent
injected_headers = otel.inject_headers(some_header_parent_context)
print(injected_headers)
```

As a result

```json
{'traceparent': '00-9de3baf546329167499556307b73b34a-c0f2d9a82006a7e8-01', 'x-b3-traceid': '9de3baf546329167499556307b73b34a', 'x-b3-spanid': 'c0f2d9a82006a7e8', 'x-b3-sampled': '1', 'b3': '9de3baf546329167499556307b73b34a-c0f2d9a82006a7e8-1-c0f2d9a82006a7e8', 'x-b3-parentspanid': 'c0f2d9a82006a7e8'}
```

> This context will be injected in every log generated by the application from the moment that we call to ```inject_headers```

In some cases we need to generate another context. Just reset the current context and inject another time.

```py
from darwin_logging.tools.otel import Otel
otel = Otel()
injected_headers = otel.inject_headers({})
print(injected_headers)
otel.reset_context() # We reset the current context, to generate another one
injected_headers = otel.inject_headers({})
print(injected_headers)
```

As the result

```sh
{'traceparent': '00-3edb3639b5b516c6c3ec75895ba0dd6b-abbff3a52a4f173d-01', 'x-b3-traceid': '3edb3639b5b516c6c3ec75895ba0dd6b', 'x-b3-spanid': 'abbff3a52a4f173d', 'x-b3-sampled': '1', 'b3': '3edb3639b5b516c6c3ec75895ba0dd6b-abbff3a52a4f173d-1-abbff3a52a4f173d', 'x-b3-parentspanid': 'abbff3a52a4f173d'}

...

{'traceparent': '00-bf2e64a7a68af0066dcac745af8136ef-b69aff261bcd70d9-01', 'x-b3-traceid': 'bf2e64a7a68af0066dcac745af8136ef', 'x-b3-spanid': 'b69aff261bcd70d9', 'x-b3-sampled': '1', 'b3': 'bf2e64a7a68af0066dcac745af8136ef-b69aff261bcd70d9-1-b69aff261bcd70d9', 'x-b3-parentspanid': 'b69aff261bcd70d9'}
```

### 4. Global Format

Currently we support the ``global format``, it means that all the traces generated by this library follows this [convention](../../../../nodejs/darwin/framework/libraries/darwin-logger.md)

#### 4.1 Adding custom attributes to Global log

In some domain/business cases we want to send data to ELK to study them.
This feature allow us to extend the ``customLog`` format attribute. In this attribute we can extend all type of data, to do it we can use:

- **Custom default format**: This context allow us to extend every customLog ```Activity and Technical```
- **Activity default format**: This context allow us to extend only Activity customLog
- **Technical default format**: This context allow us to extend only Technical customLog

> When logging custom Attributes, note that Activity and Technical custom logs take priority over Default, meaning that if an attribute is shared between Activity/Technical and Default, only the Activity/Technical will be logged
> Currently we only can extend the format in FastAPI applications.

#### 4.2 How to extend formats in FastAPI Application

To extend the logs we use [FastAPI middlewares](https://fastapi.tiangolo.com/tutorial/middleware/?h=middle)

The following ``example``:

- Creates a FastAPI application
- Set up Darwin logs
- Add a function before every request
  - Writes data into every customlog dict

```python
from fastapi import FastAPI, Request
"""Importing Logging component"""
from darwin_logging.DarwinLogs import DarwinLogs

"""Creating fastapi application"""
app = FastAPI(title=__name__)

"""Initializing logging component"""
DarwinLogs(app)

@app.middleware("http")
async def _before_request_app_(request: Request, call_next):

  request.state.default_custom_log = {
      "string_overwritten": "I will be overwritten",
      "dict_add": {"int1": 1, "string1" : "test1"},
      "no_overwritten": "Not overwritten",
      "num_overwritten": 9999,
      "bool_overwritten": False
  }
  request.state.activity_custom_log = {
      "custom_act": "Extend every ACTIVITY log",
      "string_overwritten": "I will be present in every activity log",
      "dict_add": {"int2": 2, "string2" : "test2"},
      "bool_overwritten": True
  }
  request.state.technical_custom_log = {
      "custom_tech": "Extend every TECHNICAL log",
      "string_overwritten": "I will be present in every technical log",
      "dict_add": {"int3": 3, "string3" : "test3"},
      "num_overwritten": 1234
  }
  return await call_next(request)

@app.get("/logs")
def endpoint():
  app.logger.info("This log will be extended!")
  return {"some": "response"}
```

As you can see we set three different objects in the request.state

- ```request.state.default_custom_log```
- ```request.state.activity_custom_log```
- ```request.state.technical_custom_log```

And the logs would be:

```json
{"timestamp": "2024-08-28T16:38:42.108620+02:00", "appKey": "fastapiQA", "environment": "CERT", "logLevel": "INFO", "log": "This is an example of techical log in python", "logType": "technical", "userId": "-", "parentSpanId": "518f2379b83cdbb2", "traceId": "490c626805fd7c811380668bddf21828", "spanId": "518f2379b83cdbb2", "trace_id": "490c626805fd7c811380668bddf21828", "span_id": "518f2379b83cdbb2", "parent_id": "518f2379b83cdbb2", "tracestate": "-", "error": "", "platform": "darwin", "customLog": {"contactPoint": "-", "channel": "-", "threadId": 6540, "component": "logging.py", "custom_tech": "Extend every TECHNICAL log", "string_overwritten": "I will be present in every technical log", "dict_add": {"int3": 3, "string3": "test3", "int1": 1, "string1": "test1"}, "num_overwritten": 1234, "no_overwritten": "Not overwritten", "bool_overwritten": false, "sessionId": "-", "platformLog": "PostmanRuntime/7.41.2", "appInit": "-", "paasProject": "UNSPECIFIED_PROJECT_NAME", "serverId": "UNSPECIFIED_APP_NAME"}, "company": "fake_company", "componentName": "fake_name_obs", "componentId": "fake_component_id", "componentType": "fake_component_type", "appName": "fastapiQA", "appId": "fake_app_id", "logVersion": "1.0.0", "componentVersion": "4.1.0", "isGluon": true}
```

```json
{"timestamp": "2024-08-28T16:38:42.108620+02:00", "appKey": "fastapiQA", "environment": "CERT", "logLevel": "INFO", "log": "http://127.0.0.1:8080/ POST /api/qa/logging/tech_log http 200", "logType": "activity", "userId": "-", "parentSpanId": "518f2379b83cdbb2", "traceId": "490c626805fd7c811380668bddf21828", "spanId": "518f2379b83cdbb2", "trace_id": "490c626805fd7c811380668bddf21828", "span_id": "518f2379b83cdbb2", "parent_id": "518f2379b83cdbb2", "tracestate": "-", "error": "", "platform": "darwin", "customLog": {"contactPoint": "-", "channel": "-", "threadId": 23148, "component": "DarwinLogging.py", "custom_act": "Extend every ACTIVITY log", "string_overwritten": "I will be present in every activity log", "dict_add": {"int2": 2, "string2": "test2", "int1": 1, "string1": "test1"}, "bool_overwritten": true, "no_overwritten": "Not overwritten", "num_overwritten": 9999, "sessionId": "-", "platformLog": "PostmanRuntime/7.41.2", "appInit": "-", "paasProject": "UNSPECIFIED_PROJECT_NAME", "serverId": "UNSPECIFIED_APP_NAME"}, "company": "fake_company", "componentName": "fake_name_obs", "componentId": "fake_component_id", "componentType": "fake_component_type", "appName": "fastapiQA", "appId": "fake_app_id", "logVersion": "1.0.0", "componentVersion": "4.1.0", "isGluon": true}
```

Each one allow us to extend the different customLog properties.
These extensions are on a global level, and all endpoints are affected by them.
Activity and Technical extensions take priority over default extensions, therefore, conflicting properties will be overwritten.

Here, three dictionaries are being added to the request: default_custom_log, activity_custom_log, and technical_custom_log. Each of these dictionaries has a set of keys and values that will be used somewhere later in the code.

- string_overwritten: This key is overwritten in each dictionary. This means the string_overwritten value in default_custom_log is overwritten with the value in activity_custom_log and technical_custom_log.
- dict_add: This appears to be a dictionary that is added to the default dictionary. Each dictionary (activity_custom_log and technical_custom_log) has its own dict_add that is added to the default dictionary.
- no_overwritten: This key is not overwritten because it doesn't exist in the other two dictionaries. This means the no_overwritten value in default_custom_log remains throughout the request.
- num_overwritten and bool_overwritten: These keys are overwritten in the activity_custom_log and technical_custom_log dictionaries. This means the default values in default_custom_log are overwritten with the values in the other two dictionaries.
- custom_act and custom_tech: These are keys specific to activity_custom_log and technical_custom_log respectively. They are not overwritten as they don't exist in the other dictionaries.

Finally, remember that once a data type with a specific key and value is sent, another data type or value with the same key cannot be sent.

### 5. Transport Mode

The transport mode is the way that the logs are presented. There are two different ways to send the logs:

- **Console**: This mode is used to print the logs in the console in json format.
- **Kafka**: This mode is used to send the logs to a Kafka topic and prints the logs in the console in human readable format.

> If the Kafka transport mode is enabled, the logs will be sent to the Kafka topic unless the connection to kafka fails then the profile will be console.

???+ Tip

    Look at [Environment variables](#environment-variables) to see how to configure the transport mode

### 6. Kerberos Authentication

Kerberos is a network authentication protocol that works on the basics of tickets to allow nodes communicating over a non-secure network to prove their identity to one another in a secure manner.
This library supports kerberos authentication to send logs to kafka. The kerberos authentication is enabled by default if the
environment variable `ENV` is set to `DEV`, `CERT`, `TEST`, `PRE`, `PRO`. If the environment variable `ENV` is not set, the kerberos authentication is disabled by default.
The following environment variables are used to configure the kerberos authentication:

| Key                                  |   Default value             |         Description           |
|--------------------------------------|-----------------------------| ------------------------------|
| DARWIN_LOGGING_KAFKA_HOST         | ---- | {str}: Kafka cluster URL listing. Separate multiple URLs with commas. |
| DARWIN_LOGGING_KAFKA_USERNAME | ---- | {str}: Username for Kerberos. |
| DARWIN_LOGGING_KAFKA_PASSWORD | ---- | {str}: Password for Kerberos. |
| DARWIN_LOGGING_KAFKA_MECHANISM | 'PLAIN' | {str}: SASL mechanism to use for authentication. Supports: GSSAPI, PLAIN, SCRAM-SHA-256, SCRAM-SHA-512, OAUTHBEARER |

Ensure that the kerberos username and password are set as environment variables in the environment where the application is running.

### Environment variables

| Key                               | Default                                 | Description                         |
|-----------------------------------|-----------------------------------------| ------------------------------------|
| ENV                               | `DEV`                                   | {str}: Defines the environment (DEV, CERT, TEST, PRE, PRO) for Python applications           |
| LOG_LEVEL                         | `INFO`                                 | {str}: Sets the threshold for the loggers (debug, info, warning, error, critical)            |
| DARWIN_APPKEY                     | `UNSPECIFIED_APPKEY`                    | **Deprecated** {str}: Application Key               |
| DARWIN_REGION                     | `UNSPECIFIED_REGION`                    | **Deprecated** Cluster Region                      |
| PROJECT_NAME                      | `UNSPECIFIED_PROJECT_NAME`              | Project name                        |
| APP_NAME                          | `UNSPECIFIED_APP_NAME`                  | **Deprecated** Cluster application name            |
| DARWIN_PYTHON_APPLICATION_VERSION | `UNSPECIFIED_VERSION`                   | **Deprecated** Python application version          |
| DARWIN_LOGGING_KAFKA_HOST_SECURITY_PROTOCOL | `'plaintext'`                  | Security protocol for Kafka communication |
| DARWIN_LOGGING_KAFKA_PRODUCER_ACK  | `0`                                     | The number of acknowledgments the producer requires the leader to have received before considering a request complete. |
| DARWIN_LOGGER_ENTITY              | `ESP`                                   | **Deprecated** {str}: Application Entity           |
| DARWIN_CORE_HEADERS_XCLIENTID_COMPATIBILITY    | `True`                     | {bool}: Allow to support x-santander-client-id header |
| DARWIN_LOGGING_FORMAT             | `GLOBAL`                                | {str}: Log format (GLOBAL, GLUON).      |
| DARWIN_LOGGING_MANUAL_ACTIVITY_LOG | `ACTIVITY`                             | {str}: Logger name for act_log. |
| DARWIN_LOGGING_MANUAL_TECHNICAL_LOG | `TECHNICAL`                           | {str}: Logger name for tech_log. |
| DARWIN_LOGGING_KAFKA_TECHNICAL_TOPIC | `nuar-msrv-log`                    | {str}: Defines the Kafka technical log topic |
| DARWIN_LOGGING_KAFKA_ACTIVITY_TOPIC | `nuar-act-log`                    | {str}: Defines the Kafka activity log topic |
| DARWIN_LOGGING_TRANSPORT         | `KAFKA` (if ENV is set) or `CONSOLE` (if ENV is not set)      | {str}: Transport type (KAFKA, CONSOLE). |

> The following environment variables are **deprecated** and will be removed in future versions:
>
> - DARWIN_LOGGER_ENTITY
> - DARWIN_APPKEY
> - APP_NAME
> - DARWIN_REGION
> - DARWIN_PYTHON_APPLICATION_VERSION

#### Gluon

| Key                               | Default                                 | Description                         |
|-----------------------------------|-----------------------------------------| ------------------------------------|
|DARWIN_LOGGING_COMPANY             |   `ERROR_COMPANY_NOT_DEFINED`           | {str}: Maps to the company code in Gluon.|
|DARWIN_LOGGING_COMPANY_COMPONENT_NAME |   `ERROR_COMPONENT_NAME_NOT_DEFINED` | {str}: Maps to the short-name of the component in Gluon. |
|DARWIN_LOGGING_COMPANY_COMPONENT_ID             |   `DARWIN_LOGGING_COMPANY_COMPONENT_ID` | {str}: Maps to the ID of the component in Gluon.|
|DARWIN_LOGGING_COMPANY_COMPONENT_TYPE             | `DARWIN_LOGGING_COMPANY_COMPONENT_TYPE` | {str}: Maps to the component type in Gluon. |
|DARWIN_LOGGING_COMPANY_APP_NAME            |  `DARWIN_LOGGING_COMPANY_APP_NAME` | {str}: Maps to technical application in Gluon. |
|DARWIN_LOGGING_COMPANY_APP_ID             |  `DARWIN_LOGGING_COMPANY_APP_ID`  | {str}: Maps to the technical application ID in Gluon. |
|COMPONENT_VERSION             |  `COMPONENT_VERSION`               | {str}: The version component in Gluon.  |

#### Resilience

| Key                               | Default                                  | Description                         |
|-----------------------------------|------------------------------------------| ------------------------------------|
| DARWIN_LOGGING_RETRIES           |                  `1`                     | Number of attempts to connect          |
| DARWIN_LOGGING_RETRY_TIMEOUT     |                   `5`                    | Time in seconds in which the connection keeps attempting to connect before starting a new attempt. |
| DARWIN_LOGGING_CIRCUIT_BREAK_FAILURE_THRESHOLD | `2`                        | Numbers of failures before opening the circuit |
| DARWIN_LOGGING_CIRCUIT_BREAK_NAME |           `kafka_logger`                | The name of the circuit             |
| DARWIN_LOGGING_CIRCUIT_BREAK_RESET_TIMEOUT| `10`                            | Close after this many seconds       |
