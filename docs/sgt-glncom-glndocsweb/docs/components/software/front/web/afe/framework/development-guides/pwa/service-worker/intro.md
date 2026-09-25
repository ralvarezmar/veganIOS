# Overview

A Service Worker is a script that the browser runs in the background, separate from the web page.

It can be thought of as an event-driven proxy server that is registered to a source and sits between the application, browser, and network (where available).

## What does it do?

A SW can control the web page/website it is associated with, intercepting and modifying navigation, as well as requests and storage of resources in a granular way.

Allowing control over how the application behaves in certain situations (e.g. when the network is not accessible).

In the test below, we check the availability of the blog and the Angular website when we are without network access. For both pages, we first log in with the internet active and then disable the network for verification.

For the blog, as there is no SW installed, when we disable the network we can no longer access the page, but for the main page, as there is a ***worker*** loaded and the page is within the scope.

When we disable the internet, we can access the content normally, because when the SW was registered there was the storage of some ***caches*** to respond in case of unavailable network.

## Concept

SW is a type of Web Workers, which in a general view allow us to perform actions such as triggering long-running scripts to handle computationally intensive tasks, but without blocking the user interface, so that everything occurs in parallel.

In this [example](http://afshinm.github.io/50k/) you can see a simple demonstration of the difference between sorting a COM array and SEM ***Web Workers***.

Web Workers are implemented through .js files, included through asynchronous HTTP requests on the page, these requests are completely hidden by the Web Worker API.

They're perfect for keeping the UI up-to-date, performant, and responsive to users, run in an isolated thread in the browser, and as a result, the code they run needs to be contained in a separate file.

> For more information, see: [Web Workers API](https://developer.mozilla.org/pt-BR/docs/Web/API/Web_Workers_API)

## Premise

One of the main problems that web users have suffered and still suffer is the loss/absence of connection or too slow, and even if we have accessed the best web application in the world.

The user experience would be terrible if it is not possible to download it.

Several attempts have emerged to try to solve this issue, some issues have been circumvented, but the big problem is that there was still no good control mechanism to cache ***assets*** and custom requests.

The ***Services Workers*** should finally solve this problem, being much more complete than [AppCache](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Using_the_application_cache)(previous attempt at a solution).

Using SW makes it easier to configure an app to first use ***assets*** in ***cache***, providing a standardized experience even if it's offline, before getting more data from the network.

This is already available in native apps, which is one of the main reasons why they are often more chosen than web apps.

## Features

It is worth noting some **important considerations** about ***Service Workers***:

- Runs in a worker context: so it doesn't have access to the ***DOM***.
- But alternatively, we can communicate via the ***.postMessage()*** method of the [Client](https://developer.mozilla.org/en-US/docs/Web/API/Client/postMessage) interface and the **message** event of the SW.
- It's a programmable network proxy, which allows you to control how the page's network requests are handled.
- Terminates when idle and restarts when needed again.
  - For information that must be retained and reused between restarts, Service Workers can access the [IndexedDB API](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API).
- It only works on the ***HTTPS*** protocol, but it is possible to test on ***localhost*** during development.
- Its implementation base is in the default [Promises](https://developers.google.com/web/fundamentals/primers/promises?hl=pt-br).
