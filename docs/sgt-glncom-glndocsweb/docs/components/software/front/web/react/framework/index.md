# React

Gluon will offer React ODS framework as its reference framework for React.

This framework is globally used by ODS applications. Now, powered by Gluon, every entity will be capable of using it and, furthermore, being able to reuse all the technical and functional components it is already developed over it.

You can take a look at the [key principals](https://ideal-doodle-rr76vg6.pages.github.io/web/achitecture-overview/key-principles/) of the framework in the ODS Documentarion.

Similar to our Angular frameworks, the React one provides a [Microfront architecture](https://ideal-doodle-rr76vg6.pages.github.io/web/achitecture-overview/microfrontends/).
Our mission in Gluon is to provide coexistence mechanisms to allow consume Angular Microfronts in React Shells and vice-versa. If you are interested in that use case, you can take a look at the @santander/shell library.

The main libraries of the React framework is @gruposantander/web-ui-features. If you are interested on take a look at its API, you'll find it [here](https://ideal-doodle-rr76vg6.pages.github.io/web/libraries/web-ui-features-apidocs/).

Regarding the creation of the different types of components, we are working hard to provide this three kinds from the Gluon Portal:

- React Libraries: That will help you to create technical libraries (like validators, formatters,..) or functional ones,
ODS refers to them as [Products or L1's](https://ideal-doodle-rr76vg6.pages.github.io/web/l1/introduction/).
If you want to start creating this type of component, you'll find anything you need to know in the [React Library Journey](../lib.md)

- React SPA's & Microfronts: This kind of components are not ready to be used yet from the Gluon Portal, but you can start taking a look at them [here](https://ideal-doodle-rr76vg6.pages.github.io/web/l3/introduction/)

## Deprecations

As you probably know, we offered in the past a lightweight React component for React SPA based on Create React App (CRA).
Now we mark it as deprecated. You can continue using it but, from a strategic point of view, you should starting using the new framework and components whenas soon as they are ready.

If you need more information about the deprecated CI/CD React SPA Journey, please refer to:

- [React SPA Journey](../spa.md).
