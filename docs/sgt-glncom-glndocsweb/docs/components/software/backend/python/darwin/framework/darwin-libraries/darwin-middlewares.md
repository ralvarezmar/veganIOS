# Darwin Middlewares

## Summary

**Library in charge of containing various middlewares for [FastAPI](https://fastapi.tiangolo.com/)
which is used by Darwin Python Framework.**

### 1. Introduction

This is a package for adding middlewares in FastAPI.

The `middlewares` package provides a collection of middlewares functions that can be used to enhance
the functionality of a FastAPI application. Middlewares are functions that intercept and process HTTP
requests and responses, allowing you to perform additional operations before or after the main
request handler is executed.

Currently, our implementation supports i18n features, including translation, interpolation, and pluralization. We plan to expand the library's capabilities with additional features in the future.

### 2. Internationalization (i18n)

The functionality of this package allows developers to easily add internationalization support to
their FastAPI applications. It provides features for translating text messages, interpolating
variables into translated strings, and handling pluralization rules based on the target language.

#### 2.1 Translation

Translation is the process of converting text from one language to another. In the context of i18n,
it involves creating translated versions of all the text strings used in an application so that they
can be displayed in the appropriate language based on the user's preferences or locale settings.

#### 2.2 Pluralization

Pluralization refers to how words change depending on the quantity. For example, in English, we use
"1 item" for singular and "2 items" for plural. Each language has its own rules on how plurals are
formed, and pluralization in i18n allows your application to select and display the correct form of
the text based on the specified quantity.

#### 2.3 Interpolation

Interpolation refers to the insertion of variables into text strings. For example, in a message like
"Hello, {name}!", the {name} is replaced with an actual value, like "John". Interpolation is useful
for personalizing messages based on specific user information or context.

???+ Tip

    To use this middleware, simply import it and add it to the FastAPI application as a middleware—more on that later. Once enabled, it will automatically handle the translation and localization of your application's text messages based on the user's preferred language which can be configured within the request header's `Accept-Language` key-value parameter.

### 3. Installation

We can install the library using **pip** o **pipenv**
Use the following commands to install the darwin_security package from the command line:

Pip

```bash
pip install darwin_middlewares
```

Pipenv

```bash
pipenv install darwin_middlewares
```

#### 3.1. Test

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

### 4. Configuration and integration into FastAPI microservices

#### 4.1. Configuration

Translation files are JSON-formatted files that store language-specific text for applications.
In Kubernetes, these files will be managed using `ConfigMaps`, allowing dynamic and centralized
control of multi-language support without needing to redeploy the application.

Translation file examples:

```bash
/locale/en.json
```

```json
{
    "hello_world": "Hello World",
    "hi" : "Hi %{name} %{lastname} !",
    "mail_number" : {
        "zero": "You do not have any mail.",
        "one": "You have a new mail.",
        "few": "You only have %{count} mails.",
        "many": "You have %{count} new mails."
    },
    "error__ZeroDivisionError" : "You can not divide by zero."
}
```

```bash
/locale/es.json
```

```json
{
    "hello_world" : "Hola Mundo",
    "hi" : "Hola %{name} %{lastname} !",
    "mail_number" : {
        "zero": "No tienes ningun correo.",
        "one": "Tienes un nuevo correo.",
        "few": "Tienes solo %{count} correos.",
        "many": "Tienes %{count} nuevos correos."
    },
    "error__ZeroDivisionError" : "No se puede dividir por cero."
}
```

???+ Tip

    For detailed guidance on configuring and mapping a ConfigMap to the translation files in Gluon, [visit this web](../../../../../../configuration/kubernetes/configmaps-rm.md#configmap-to-file)

???+ Tip

    For more information about ConfigMaps in Kubernetes, [visit this web](https://kubernetes.io/docs/concepts/configuration/configmap/)

#### 4.2 Integrating Internationalization (i18n) into FastAPI Microservice

Before importing the library we must set these [environment variables](#5-environment-variables).

```python
from fastapi import FastAPI, Request

""" Import Middleware module """
from darwin_middlewares.i18n.middleware import I18nMiddleware

"""Creating FastAPI application"""
app = FastAPI(title="FastAPI")
app.add_middleware(I18nmiddleware, config={"fallback": "en"})

@app.get("/i18n")
async def main(request: Request):

    message = request.state.translator("hello_world")

    return {"status": "OK",
            "message": message
          }

@app.get("/i18n_interpolation")
async def main(request: Request):

    name = request.headers.get("name", "Jhon")
    lastname = request.headers.get("lastname", "Doe")

    message = request.state.translator("hi", **{"name" : name , "lastname" : lastname})

    return {"status": "OK",
            "message": message
          }

@app.get("/i18n_pluralization")
async def main(request: Request):

    num = request.headers.get("num", 0)

    message = request.state.translator("mail_number", **{"count" : int(num)})

    return {"status": "OK",
            "message": message
          }
```

### 5. Environment Variables

The darwin_middlewares library requires the configuration of 2 environment variables:

| Key                               | Default                                 | Description                         |
|-----------------------------------|-----------------------------------------| ------------------------------------|
| DARWIN_MIDDLEWARES_I18N           |                  `"False"`                | Allows the internationalization of the microservice |
| DARWIN_MIDDLEWARES_I18N_LOCALES   |                  `"/etc/i18n/locales"`                    | The path to the folder languages with json files, and should not be empty  |
