---
title: Custom Decorators for FastAPI Endpoints
---

This article provides a solution for implementing custom decorators in FastAPI, with a specific focus on designing a decorator to
propagate headers and integrating it seamlessly with FastAPI endpoints. The document will guide you through the process of creating a header propagation decorator, explaining its purpose, and how to effectively apply it to FastAPI routes.

## Introduction

Decorators are a design pattern in Python that allows the extension of new functionality to an existing function or method by wrapping them with additional functionality. They are widely used in frameworks like FastAPI to enhance code modularity and
reusability. A decorator essentially allows one function to modify another without changing the original function's code directly.

Here's a basic example:

```python
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("Before function call")
        result = func(*args, **kwargs)
        print("After function call")
        return result
    return wrapper

@my_decorator
def say_hello():
    print("Hello!")

say_hello()
```

In this example, `@my_decorator` is applied to `say_hello`, allowing custom behavior before and after the function execution.

???+ Tip

    For more information about Decorators in Python, [visit this web](https://realpython.com/primer-on-python-decorators/)

### FastAPI and Decorators

In FastAPI, decorators are heavily used to define routes (@app.get, @app.post, etc.). These decorators map functions to HTTP
endpoints, but FastAPI also supports creating custom decorators to introduce additional functionality, such as propagating
headers, validating requests, or handling authentication.

Custom decorators, like those for propagating HTTP headers (discussed in detail in this article), streamline your code by reducing redundancy, making endpoints easier to maintain and extend.

## Problem Statement

Efficiently propagating specific headers from incoming requests to outgoing responses within FastAPI endpoints is a common
requirement, but implementing this across multiple routes can lead to repetitive and cluttered code. The challenge is to create a
reusable, flexible solution that maintains clean, modular code while ensuring consistent header propagation across the application.

## Solution

The solution involves creating a custom decorator in FastAPI that extracts specific headers from incoming requests and adds them
to outgoing responses. By applying this decorator to relevant endpoints, we achieve consistent header propagation while
maintaining clean, modular, and reusable code across the application.

## Steps to Implement the Solution

### Define a FastAPI Application

```python
# main.py
from fastapi import FastAPI

app = FastAPI()

```

### Create a Custom Decorator: propagate_header

Next, we implement the `propagate_header` decorator that checks for the presence of `businessid` and `sessionid` in the request headers. If the decorator is called with `generate='next'` argument, it will generate a new businessid.

```python
# decorators.py
from fastapi import Request, Response
from functools import wraps
import uuid

def propagate_header(generate: str = None):
    def decorator(func):
        @wraps(func)
        async def wrapper(request: Request, *args, **kwargs):
            # Extract headers from the incoming request
            business_id = request.headers.get('businessid')
            session_id = request.headers.get('sessionid')

            # If generate='next', generate a new businessid
            if generate == 'next':
                business_id = str(uuid.uuid4())  # Generate new UUID as businessid

            # Call the actual function (route handler)
            response = await func(request, *args, **kwargs)

            # Propagate the headers if they exist
            if business_id:
                response.headers['businessid'] = business_id
            if session_id:
                response.headers['sessionid'] = session_id

            return response
        return wrapper
    return decorator

```

???+ Important

    In FastAPI, path functions are defined asynchronously to handle non-blocking I/O operations efficiently. Therefore, in the `propagate_header` decorator, the `response = await func(request, *args, **kwargs)` statement is necessary because it awaits the asynchronous execution of the route handler. Additionally, the `wrapper` function itself must be defined as async to support asynchronous operations in FastAPI and ensure proper handling of the response.

???+ Tip

    The `@wraps` decorator from Python’s functools module is crucial when defining custom decorators. It preserves the original function’s metadata, such as its name, docstring, and other attributes, which would otherwise be lost. This helps maintain better debugging and introspection capabilities. [Visit this web](https://docs.python.org/3/library/functools.html#functools.wraps)

???+ Tip

    In this implementation, we used Python’s `uuid` module to generate a new unique businessid. The uuid4() function creates a random universally unique identifier (UUID) that ensures the generated ID is highly unlikely to clash with any existing values. This is especially useful when you need to generate a new unique identifier on demand. [Visit this web](https://docs.python.org/3/library/uuid.html)

### Implement FastAPI Endpoints and Apply the Custom Decorator

Finally, we define FastAPI endpoints, import and apply the `propagate_header` decorator to automatically handle header propagation.

```python
# main.py
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from decorators import propagate_header  # Import the custom decorator

app = FastAPI()

# Apply the decorator to FastAPI endpoints

@app.get("/items")
@propagate_header()
async def read_items(request: Request):
    return JSONResponse(content={"message": "Items retrieved successfully"})

@app.get("/generate-business-id")
@propagate_header(generate="next")
async def generate_business_id(request: Request):
    return JSONResponse(content={"message": "New businessid generated and propagated"})

```

## How the Solution Works

The custom `propagate_header` decorator intercepts incoming requests, checks for `businessid` and `sessionid` in the headers, and
automatically adds them to the response. If the decorator is called with `generate="next"`, it generates a new `businessid` using
UUID. This eliminates redundant code and ensures consistent header handling across endpoints.

Example:

> For `/items` endpoint:

```bash

curl -X GET "http://127.0.0.1:8000/items" -H "businessid: 123" -H "sessionid: 456"
```

In this case, the `businessid` and `sessionid` are propagated to the response.

![response header propagated](./images/response-decorator-headers1.png)

> For `/generate-business-id` endpoint:

```bash

curl -X GET "http://127.0.0.1:8000/generate-business-id"
```

In this case, a new `businessid` is generated and returned in the response, along with the existing `sessionid` if provided.

![response header propagated-next](./images/response-decorator-headers2.png)

## Conclusion

By using a custom `propagate_header` decorator in FastAPI, we achieve efficient and consistent header propagation across multiple
endpoints. This approach minimizes code duplication, enhances maintainability, and allows for dynamic logic, such as generating
new values for headers when needed.
