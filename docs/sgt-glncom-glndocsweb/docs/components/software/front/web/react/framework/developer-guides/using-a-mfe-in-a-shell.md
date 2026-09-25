# How to integrate a Microfront inside a Shell

## Overview

The **React Shell** and **Microfront** archetypes that Gluon offers are **based on Module Federation**, a technique (originally created by Webpack) that allows
the **sharing of modules** between the container *(Shell)* and remote apps *(Microfronts)*.

It will enable the Shell to **dynamically load** and run Microfronts **as if they were part of the Shell** itself.

**Microfronts can expose specific modules** that the Shell consume, enabling code sharing and seamless integration.

Pros:

- **Code remains in place** — By adding the plugin configuration, the module federation can be achieved. It allows us to keep the code logic without modifying it.
- **Run-time code sharing** — The modules are federated in run-time. The microfronts can be managed and deployed independently.
The changes of the microfronts can be reflected immediately if it deploys to the production.
- **Framework agnostic** — we can use the same code if we are using the same framework
- **No code loaders** — No code loaders are required

## Defining a new microfront in the Shell

In the Shell project we can configure vite in the `vite.config.ts` file *(in the root folder)*.

``` typescript
/// <reference types="vitest" />
import federation from '@originjs/vite-plugin-federation';
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    federation({
      name: 'app',
      remotes: {
        remoteApp: '/remoteApp/assets/remoteEntry.js',
      },
      shared: ['react', 'react-dom'],
    }),
  ],
  build: {
    target: 'esnext',
    rollupOptions: {
      output: {
        manualChunks: {
          react: ['react', 'react-dom'],
        },
      },
    },
  },
  server: {
    proxy: {
      '/remoteApp': {
        target: `http://localhost:4174`,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/remoteApp/, ''),
        secure: false,
      },
    }
  },
  preview: {
    proxy: {
      '/remoteApp': {
        target: `http://localhost:4174`,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/remoteApp/, ''),
        secure: false,
      },
    }
  },
  test: {
    ···
  }
})
```

We should take a look to different topics here:

### How to match the remote entries for every microfront

In the plugins definition, we can see how to configure the federation plugin to define the remotes:

``` typescript
···
export default defineConfig({
  plugins: [
    ···
    federation({
      name: 'app',
      remotes: {
        remoteApp: '/remoteApp/assets/remoteEntry.js',
      },
      shared: ['react', 'react-dom'],
    }),
  ],
  ···
})
```

Here we can see how a new entrypoint *(called `remoteApp`)* is defined and how it is resolved in the following URL `/remoteApp/assets/remoteEntry.js`.
We can define as many entrypoints in our Shell as we need, we need only to remember that the entrypoint should be unique for this Shell *(in this case, the unique id for the entrypoint will be `remoteApp`)*

Please note, when we are in localhost, the full URL for the `remoteApp` entrypoint will be something like `http://localhost:port/remoteApp/assets/remoteEntry.js`
but when the Shell is deployed at CERT, PRE or PRO environment, the URL will be something like `http://something.com/remoteApp/assets/remoteEntry.js`.

The module federation plugin will be configure same way for all the environments *(LOCAL, CERT, PRE & PRO)* and we will leverage
on the underlying server to do the proxy to the final location.

Take a look to the following sections to know how to configure it for [local](#how-to-acquire-the-remote-module-when-running-in-local) or [runtime environment](#how-to-acquire-the-remote-module-when-running-at-kubernetes).

Besides that, we can see in the 'shared' key that the Shell is sharing the `react` and `react-dom` modules.
This means that these modules will be available for remotes and, if they need them, the modules will not be loaded again, reusing the ones provided by the Shell.

### How to build the application

As the `react` and `react-dom` are shared across the Shell and the Microfront, we can configure Vite to allow the creation of a custom shared common chunk.
This way, we create a `react` manual chunk that represents a chunk that contains both modules and all their dependencies. You can know more about this in the [rollup documentation](https://rollupjs.org/configuration-options/#output-manualchunks){:target="_blank"}.

``` typescript
···
export default defineConfig({
  ···
  build: {
    ···
    rollupOptions: {
      output: {
        manualChunks: {
          react: ['react', 'react-dom'],
        },
      },
    },
  },
  ···
})
```

### How to acquire the remote module when running in local

When we run the application in our local machine, we need to configure the vite server to locate the remote entry.
It could be also run on your local machine or in a CERT, PRE or PRO environment, you can configure it in the `server` and `preview` configuration keys.

``` typescript
···
export default defineConfig({
  ···
  server: {
    proxy: {
      '/remoteApp': {
        target: `http://localhost:4174`,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/remoteApp/, ''),
        secure: false,
      },
    }
  },
  preview: {
    proxy: {
      '/remoteApp': {
        target: `http://localhost:4174`,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/remoteApp/, ''),
        secure: false,
      },
    }
  },
  ···
})
```

These configuration will replace the following URL `http://localhost:port/remoteApp/assets/remoteEntry.js` to something like `http://localhost:4174/assets/remoteEntry.js`.
The final URL should be the URL of the final remoteEntry for the Microfront.

### How to acquire the remote module when running at kubernetes

When we are in a kubernetes environment *(CERT, PRE or PRO)* the Shell is running inside an nginx, so the equivalent proxy configuration should be done in the nginx configuration.

We should do it at the default.conf file

``` bash
···
server {
  ···
  # Include this entry as many times as microfronts you want to include
  location ~ ^/remoteApp {
    rewrite ^/remoteApp/(.*) /$1 break;
    proxy_pass https://companyId-appId-microfrontId-sanes-pre-vostok-dev.apps.ccc01alm.ccc.pre.cn2.paas.cloudcenter.corp;
  }
  ···
}
```

With the following configuration, we are instruction nginx to rewrite every request to /remoteApp and redirecting them to the Microfront pod.

These way, when the module federation plugin (running in the Shell) will request the remote entry for the microfront (as a local file in the same pod):

`https://companyId-appId-spaId-sanes-pre-vostok-dev.apps.ccc01alm.ccc.pre.cn2.paas.cloudcenter.corp/remoteApp/assets/remoteEntry.js`

The nginx will resolve that URL as the following one (requesting it to the microfront pod):

`https://companyId-appId-microfrontId-sanes-pre-vostok-dev.apps.ccc01alm.ccc.pre.cn2.paas.cloudcenter.corp/assets/remoteEntry.js`

## Configuring the Microfront

In the Microfront we will have the same file to configure vite *(vite.config.ts in the root folder)* but, despite on the Shell configuration,
we will not define remote entries. We will define the exposed modules for this entrypoint

``` typescript
/// <reference types="vitest" />
import federation from '@originjs/vite-plugin-federation';
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    federation({
      name: 'remote_app',
      filename: 'remoteEntry.js',
      exposes: {
        './MfeApp': './src/App.tsx',
      },
      shared: ['react', 'react-dom'],
    }),
  ],
  build: {
    target: 'esnext',
    rollupOptions: {
      output: {
        manualChunks: {
          react: ['react', 'react-dom'],
        },
      },
    },
  },
  test: {
    ···
  }
})
```

These way, we can focus on the federation plugin configuration:

``` typescript
···
export default defineConfig({
  plugins: [
    react(),
    federation({
      name: 'remote_app',
      filename: 'remoteEntry.js',
      exposes: {
        './MfeApp': './src/App.tsx',
      },
      shared: ['react', 'react-dom'],
    }),
  ],
  ···
})
```

We can see several things here:

- The entrypoint file name will be `remoteEntry.js`. So.. when the Shell will want to load the remote, it will need to consume it from this URL: `http://domain/assets/remoteEntry.js`
- Inside the remote entry, it will be exposed a unique module called `MfeApp` *(you can define as many as you want)*
- The `MfeApp` module is implemented in the module offered by the `App.tsx` file.

## Wrapping up the Shell and the Microfront integration

Once you have configure the [Shell](#defining-a-new-microfront-in-the-shell) and the [Microfront](#configuring-the-microfront)
you are in the right position to finally consume the Microfront inside the Shell.

To do so, you just need to import the remote module of the microfront and to display it inside your application.

``` typescript
···
const MfeApp = lazy(() => import('remoteApp/MfeApp'));

function App() {
  return (
    <>
      <div>
        <h1>Gluon Microfront</h1>
        <Suspense fallback={<div>Cargando...</div>}>
          <MfeApp />
        </Suspense>
      </div>
    </>
  )
}

export default App
```

You can easily import the remote module this way:

``` typescript
const MfeApp = lazy(() => import('remoteApp/MfeApp'));
```

And display it as it were a React component

``` typescript
function App() {
  return (
    ...
    <MfeApp />
    ···
  )
}

export default App
```

Please note: As we are using typescript, we need to declare the remote module in the `declarations.d.ts` in the `src` folder

``` typescript
declare module 'remoteApp/MfeApp' {
  const MfeApp: React.ComponentType;
  export default MfeApp;
}
```
