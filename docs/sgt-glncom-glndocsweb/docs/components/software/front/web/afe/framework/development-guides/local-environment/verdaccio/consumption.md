# Local consumption

To install the locally published package we need to change the project's registry so that it downloads from ***verdaccio***.

We can do this in two ways:

## Changing the global registry

To do this, we must change the ***registry*** in ***.npmrc*** through the following command:

``` BASH
npm install --registry http://localhost:4873/
```

And then run the ***install*** command from the published dependency.

> This change to ***.npmrc*** should not be published on ***GitLab***, because trying to pass this project on the ***DevOps*** treadmill will fail due to the ***registry*** not being found.

## Passing the '--registry'parameter

Another way is to pass the ***registry*** as a parameter during the ***install*** command like the example below:

``` BASH
npm install --registry http://localhost:4873/
```

> Just as the change to ***.npmrc*** should not be published, if the project has enabled the generation and publication of the ***package-lock.json*** file, it is recommended that you take the same care as it impacts the purpose of using ***package-lock.json***.

Once this is done, the library is already installed in the project and local tests can be done before the official publication of the library on ***artifactory***!
