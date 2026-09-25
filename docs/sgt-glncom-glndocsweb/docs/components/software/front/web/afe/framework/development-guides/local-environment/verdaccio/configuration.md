# Configuration

To start the setup, run the following command to generate the default settings and leave Verdaccio running:

``` BASH
npx verdaccio
```

When you run this command, one of the first lines that will be displayed in the terminal will be the path to the Verdaccio configuration file. This file is a ***YAML*** and should look similar to the example below:

``` YAML
#
# This is the default config file. It allows all users to do anything,
# so don't use it on production systems.
#
# Look here for more config file examples:
# https://github.com/verdaccio/verdaccio/tree/master/conf
#

# path to a directory with all packages
storage: ./storage
# path to a directory with plugins to include
plugins: ./plugins

web:
  title: Verdaccio
  # comment out to disable gravatar support
  # gravatar: false
  # by default packages are ordercer ascendant (asc|desc)
  # sort_packages: asc
  # convert your UI to the dark side
  # darkMode: true

# translate your registry, api i18n not available yet
# i18n:
# list of the available translations https://github.com/verdaccio/ui/tree/master/i18n/translations
#   web: en-US

auth:
  htpasswd:
    file: ./htpasswd
    # Maximum amount of users allowed to register, defaults to "+inf".
    # You can set this to -1 to disable registration.
    # max_users: 1000

# a list of other known repositories we can talk to
uplinks:
  npmjs:
    url: https://registry.npmjs.org/

packages:
  '@*/*':
    # scoped packages
    access: $all
    publish: $authenticated
    unpublish: $authenticated
    proxy: npmjs

  '**':
    # allow all users (including non-authenticated users) to read and
    # publish all packages
    #
    # you can specify usernames/groupnames (depending on your auth plugin)
    # and three keywords: "$all", "$anonymous", "$authenticated"
    access: $all

    # allow all known users to publish/publish packages
    # (anyone can register by default, remember?)
    publish: $authenticated
    unpublish: $authenticated

    # if package is not available locally, proxy requests to 'npmjs' registry
    proxy: npmjs

# You can specify HTTP/1.1 server keep alive timeout in seconds for incoming connections.
# A value of 0 makes the http server behave similarly to Node.js versions prior to 8.0.0, which did not have a keep-alive timeout.
# WORKAROUND: Through given configuration you can workaround following issue https://github.com/verdaccio/verdaccio/issues/301. Set to 0 in case 60 is not enough.
server:
  keepAliveTimeout: 60

middlewares:
  audit:
    enabled: true

# log settings
logs:
  - { type: stdout, format: pretty, level: http }
  #- {type: file, path: verdaccio.log, level: info}
#experiments:
#  # support for npm token command
#  token: false
#  # support for the new v1 search endpoint, functional by incomplete read more on ticket 1732
#  search: false

# This affect the web and api (not developed yet)
#i18n:
#web: en-US
```

Because the goal is to publish versions of **local** libraries, you do not need to be authenticated for publishing. To modify this, just replace the occurrences of the value `$authenticated` with `$all`.

> If you are going to use Verdaccio for processes other than the one above, it is recommended that you keep the need for authentication.

Another point of note is that if you try to install a version of a library that is not published to your instance of Verdaccio, it will try to install from registry ***<https://registry.npmjs.org/>***.

To make it point to the ***artifactory***, you need to make the following changes:

Add a new ***uplinks*** called ***artifactory*** as in the example below:

``` YAML
uplinks:
  npmjs:
    url: https://registry.npmjs.org/
  artifactory:
    url: http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all
```

And also change the proxy settings to use the artifactory value as follows:

``` YAML
proxy: artifactory
```

> After any change in the configuration file, it is necessary to stop its execution and run the command again so that it reflects the changes.
