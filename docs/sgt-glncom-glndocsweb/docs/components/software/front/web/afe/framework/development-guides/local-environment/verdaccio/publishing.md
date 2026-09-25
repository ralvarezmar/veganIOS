# Local Publishing

> Before following the guidelines below, make sure that verdaccio is running on a terminal.

For the ***library*** project that you want to test in another project, you just need to run the ***build*** command:

``` BASH
npm run build
```

After the success of the ***build*** the following command should be executed:

``` BASH
npm publish ./dist --registry http://localhost:4873/
```

At this time a version of the library was published in the local registry. To confirm or consult the versions already published, go to the url where ***verdaccio*** is being served ***<http://localhost:4873/>***
