# App Shell

***App Shell*** is an architectural model for instantaneous application loading in ***Progressive Web App*** (***PWA***)

This architecture is used to bring the user the same experience as a native app on a mobile device.

For instant loading to happen, the App Shell must have only the ***HTML***, ***CSS*** and ***JavaScript*** minimum for the application to work. This content is loaded on the first access, and there is no need to load on the other accesses even when offline.

The use of ***App Shell*** is recommended for ***Single Page Application*** (***SPA***) that are heavy and require a quick response to the user at their startup.

This architecture is based on the use of ***Aggressively Caching*** of the basic application through a ***Service Worker***.

## How does it work?

On the first access to the application (***PWA***), the ***App Shell*** load is performed and the ***Service Worker*** creates a permanent cache (***Aggressively Caching***) on the device, after which the rest of the application is loaded.

With this, on a second access the ***App Shell*** no longer needs to be loaded and will be displayed even without an internet connection, thus simulating a native application.

## What should be in an App Shell?

The recommended content for the App Shell is the minimum that your application can display without the need for an internet connection, such as the following:

- Application logo
- Hamburger menu
- Application header
- Application footer
- Informative
- Authentication screen
- Load screen

> No dynamic content can be in the App Shell.

## Example of the structure of an App Shell

![Example of the structure of an App Shell] (./images/appshell.png)

> The App Shell is cached to load instantly on future visits.
> Dynamic content will only load if the application has an internet connection.

In this case, the App Shell will behave like a native mobile app.

As we can see, the structure has only the skeleton of the ***UI*** with the main components for its operation, but without dynamic content.

## Benefits

The benefits of an App Shell with Service Worker are:

- **Performance**: The base structure files are stored in ***cache***, thus ensuring a fast opening response for the user.
- **Iterations as a native app**: The ***app shell*** model provides the experience of browsing and operating offline like a native app.
- **Data Saver**: With the well-designed application, it is possible to save on data traffic by keeping static files cached.
