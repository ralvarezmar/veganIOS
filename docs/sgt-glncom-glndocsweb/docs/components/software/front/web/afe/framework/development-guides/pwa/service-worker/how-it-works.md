# How it works

To have the reference of how it works, we must look at the ***Web Workers***, because as already said a SW is a type of ***Web Worker***.

- They are implemented as ***.js*** files that are included via asynchronous ***HTTP*** requests on the page, and these requests are completely hidden by the ***API*** of the ***Web Worker***.
- Workers use threading to achieve parallelism.
- They're perfect for keeping the UI up-to-date, performant, and responsive for users.
- Are executed in an isolated thread in the browser. As a result, the code they execute needs to be contained in a separate file. It's very important to remember that.
- If the ***task.js*** file exists and is accessible, the browser will generate a new ***thread*** and download the file asynchronously, once the download is complete, it will run and ***worker*** will start.
- If the path provided to the file returns a 404, the ***worker*** will silently fail.

## Service Worker Update

A SW update is triggered:

- Whether a navigation to a page in scope occurs;
- On functional events such as ***push*** and ***sync***, unless an update check has occurred in the last 24 hours;
- On the call from ***.register()*** only if the SW URL has been changed.

The steps of this process occur according to the procedures listed below:

- The SW is considered up-to-date if it differs, at the byte level, from what the browser already has.
- The updated SW initializes along with the one that already exists and receives its own **install** event.
- If the new worker has a status code other than "OK" (e.g., 404), fails to parse, triggers an error during execution, or is rejected during installation, it will be discarded, but the current worker will remain active.
- Once installed, the updated worker goes into a **wait** state until the existing one is not controlling any clients (pages of its scope).
- Using ***self.skipWaiting()*** avoids waiting, which means that SW is activated as soon as the installation is complete.
