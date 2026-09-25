# Webpack 5

## Web worker support

***Webpack 5*** now includes support for ***web workers***. However, the URL structure in the ***builder*** must be in a specific format that differs from the current requirement.

To update the use of ***web worker***, change `new Worker('./app.worker', ...)` to `new Worker(new URL('./app.worker', import. meta.url), ...)`,

## Change in file generation using the ***namedChunks*** option

- ***Webpack 5*** generates similar files, but with different names, to files loaded via ***lazy loading*** in the local development environment when the ***namedChunks*** option is enabled.
- For most users, this change should not affect the application or the build process.
- Production builds should also not be affected, as the ***namedChunks*** option is disabled by default in production configurations.
- However, if a project's post-build process makes assumptions about file names, adjustments may need to be made to account for the new naming paradigm.
- These post-build processes can include custom post-build file transformations, integration into service frameworks, or deployment procedures.
- An example of a development file name change is ***lazy-lazy-module.js*** becoming ***src_app_lazy_lazy_module_ts.js***.
