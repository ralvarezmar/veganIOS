# Setting up ***replace.tokens***

> **❌ Warning**
>
> You need to carefully follow the following steps:

## Set up the conf.d/replace.tokens file

The first step is to configure our ***conf.d/replace.tokens*** file with all the occurrences that should be replaced during the ***deploy*** of the application with the **environment variables** that we will create.

In the example below we will replace the ***alias*** **/hub-url** that is used at the time of **local development** to make calls to **Service Hub**.

Using the [***proxy***](../../../local-environment/proxy.md), with the variable that will store the value of the ***host*** that we are going to consume.

> **❗ Information**
>
> The ***token*** that will be replaced is **defined by the application itself**, and it is necessary to analyze how they were declared in the project, so that they are configured correctly in ***replace.tokens***.

``` BASH
/hub-url=${HUB_HOST}
```

> **⚠️ Nota**
>
> It is important to note that ***tokens*** with partially similar names can cause problems when replacing variables.
>
> **Wrong:**
>
> - ***/alias-example***
> - ***/alias-example-full***
>
> **Correct:**
>
> - ***/alias-example***
> - ***/alias-full-example***
>
> **It is recommended to use different names to avoid such problems.**

## Add the line break at the end of the file

Add a line break at the end of the file, to ensure that the last declared variable is read correctly and that your ***replace*** is done correctly.

Two or more line breaks at the end of the file can cause the ***tokens[$key]: bad array subscript*** error When editing the file, it is **important** to save it with ***encoding*** **UTF-8** and ***LF*** line break instead of ***CRLF***.

That way, whenever the ***/hub-url*** occurrence is found within the application.

It will be replaced with the environment variable ***${HUB_HOST}***. However, we haven't set a value for it yet. To do this, we'll need to set the variable value for each environment.

> **Attention**
>
> **If you are using Windows**, you will need to configure the formatting of the **replace.tokens** file, to avoid errors such as 'Invalid or unexpected token' or 'unexpected EOF' when accessing the application.
