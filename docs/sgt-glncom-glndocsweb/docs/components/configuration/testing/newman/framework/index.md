---
hide:
  - toc
---

# Newman Documentation

## Introduction

<!--Newman introduction start-->

**Newman**  is a command-line collection runner for [Postman](https://learning.postman.com/docs/introduction/overview/). It enables you to run and test a Postman collection directly from the command line. It allows the automation of API tests.

Before starting to work with Newman, it's key to understand what Postman collections are and why they should be used.

Collections allow you to group individual requests. These, in turn, may contain folders that further group these requests. Collections and their
subfolders help the developer keep related requests together. This makes their organization much easier, making them much more findable and recognizable.
Additionally, this allows you to create test suites that group tests for different associated requests, which makes it easier to create integration tests.

Newman makes it easy to run and test Postman collections.

Additional information and documentation can be found at the official web of [Newman](https://learning.postman.com/docs/collections/using-newman-cli/command-line-integration-with-newman/).

<!--Newman introduction end-->

----

## Getting started

To get started, install [Node.js](../../../../../getting-started/setup-your-environment/technologies/javascript-node.md) and Newman, then run your collections. Learn more about [installing and running Newman](../journey/newman-testing-journey.md#execute).

## Options

Newman provides a rich set of options to customize a run. Learn more about [Newman options](https://learning.postman.com/docs/collections/using-newman-cli/newman-options/){:target="_blank"}.

## Framework features

Newman framework has several features that help the development of test cases:

### Data file

Newman enables you to use a CSV or JSON file, and use the values from the data file in Collection Runner. You can consult the official documentation at [Run collections using imported data](https://learning.postman.com/docs/collections/running-collections/working-with-data-files/){:target="_blank"}

To use a data file in Gluon Testing Portal call the file *datafile.json* and put it in the same location as the collection.

### Hide sensitive requests

When the project is run from Gluon Testing, at the end of the execution a report will be generated with the results of the execution and the requests made. If it is necesaary to hide some requests because contains sensitive data, it will follow the notation:

- **Folder:** There is the option to hide an entire folder or subfolder by renaming it PRIVATE FOLDER. This way, we will only show the requests from this folder in the logs and in the number of total requests.
- **Request:** There is the option to only hide the body of the request. To do that the request must be named PRIVATE REQUEST. This way only the headers will appear in the report.
- **Headers:** The following headers are always hidden: Authorization, x-clientid and X-ClientId

### Encrypt credentials

In the project template there is a script in the Pre-request tab. There are three sections in it:

- The first is a script to encrypt passwords with a passphrase that we will later store in the Gluon Testing Portal. We will only activate it (encrypted = true) when we want to encrypt a password,
to do this we add the passphrase to the *passPhrase* field and the password to the *pass* field; It will return to us through the console the encrypted value that will be the one that we will add to the environment variables.
- The second is the decryption of those passwords using the passphrase.
To decrypt a value we have to pass the passphrase in the *v_passphrase* field, with this the script will be in charge of decrypting the value of the *passEnc* variable and saving it in the *passDec* variable.
- The third is an example of a request to the corporate login to obtain a token. As you can see, to make this request the environment variable generated in the previous step *passDec* is used.

## Related content

[Newman Journey](../journey/newman-testing-journey.md)

[Testing portal](../../../../../application/qatesting/testing/portal/testing-portal/index.md)
