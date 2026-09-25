# Change Log

## 5.2.3 - RELEASE ChangeLog

```commandline

- Provides the capability to run in debug using RemoteWebDriver and have visual confirmation of the execution by using applicationtype=debug
- Offers support for testing frameworks inside github runners and aws executions
- Adds capability for adding http.proxyHost, https.proxyHost, http.nonProxyHosts, https.nonProxyHosts
- Stores package version into postgres
- Library can be used outside of Santander network by flattening some of the internal transitive dependencies
- Technical design improvements including removal of multiple transitive dependencies
- Fixing issue related to browser proxy settings
- JODA time usage upgraded to Java code Datetime library
- Dependent library for AWS SDK and Hadoop Hive taken out to reduce download time
- Project needing these libraries to include it separately in their project POM
- To make the current nitrowebkit compatible with selenium 4 and Appium 8.
- Integrated sauce lab with the current version of nitrowebkit.
- Appium version upgraded to 8.5.1
- Added new properties to bootstrap file for country and screenshot at step level.
- Implements selenium 4.13.0
- Added deque library for accessibility testing.

Selenium v.4.13.0 CHANGELOG

- Supported CDP versions: 85, 115, 116, 117
- Deprecate setScriptTimeout(), use scriptTimeout()
- Remove deprecated method move on Point class
- Remove deprecated method GeckoDriverService usingFirefoxBinary, use setBinary
- Remove deprecated method GeckoDriverService createDefaultService with capabilities
- Remove deprecated onConsoleLog in BiDi LogInspector
- Fix NewSession Runner (#12700)
- Add 'getArray' method for array values (#12703)
- Ensure HttpClients not closed while waiting for responses
- Fix bug for overwriting driver log output stream passed in by user
- Update pinned browser versions
- Improve stability with final variables (#12733)
- Fix bug for Appium subclass that sets neither log file nor output (#12696)
- Remove deprecated headless methods from Options classes
- Remove deprecated driver service constructors and methods
- Remove deprecated log_file methods
- Allow users to set Selenium Manager path by environment variable (#12752)

```
