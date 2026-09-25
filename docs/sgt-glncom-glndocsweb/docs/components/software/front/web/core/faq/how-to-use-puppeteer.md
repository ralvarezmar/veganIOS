# How to use Puppeteer

Puppeteer is a Node library that provides a high-level API to control Chrome or Chromium over the DevTools Protocol. It can also be configured to use full (non-headless) Chrome or Chromium.

## Installation

You'll need to install Puppeteer by running the following command:

```bash
npm install puppeteer@19.7.5 --save-dev
```

!!! warning

     It is **important** to use this **specific version (19.7.5)** because there are some issues regarding the binary download of Chromium from the latest Puppeteer versions behind corporative proxies.

### Configuring Karma

Once it is installed, you'll need to configure Karma to use it. It is as simple as adding the following lines to your `karma.conf.js` file:

```javascript title="Sample for karma.conf.js" linenums="1" hl_lines="3 4"
// Karma configuration file, see link for more information
// https://karma-runner.github.io/1.0/config/configuration-file.html
const puppeteer = require('puppeteer')
process.env.CHROME_BIN = puppeteer.executablePath();

module.exports = function (config) {
    // .. your karma configuration
};
```
