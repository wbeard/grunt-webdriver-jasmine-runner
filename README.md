# grunt-webdriver-jasmine-runner

A grunt plugin that runs jasmine tests using webdriver.

## Getting Started
This plugin requires Grunt `~0.4.0`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out
the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create 
a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins.

Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install git+ssh://git@github.com:RallySoftware/grunt-webdriver-jasmine-runner.git
```

If you do not have stored ssh credentials for github, you will need to authenticate
to complete the installation.

The module can also be installed with package.json by adding a reference to the devDependencies block:

```js
{
    "name": "your-app-name",
    "version": "99.99.99",
    "devDependencies": {
        "private-repo": "ssh://git@github.com:RallySoftware/grunt-webdriver-jasmine-runner.git"
    }
}
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-webdriver-jasmine-runner');
```

## The "webdriver_jasmine_runner" task

### Overview
In your project's Gruntfile, add a section named `webdriver_jasmine_runner` to the data object passed 
into `grunt.initConfig()`.

```coffee
grunt.initConfig
  webdriver_jasmine_runner:
    your_target:
        options:
            # your options here
```

### Options

#### Summary (w/ default values)

```coffee
      seleniumJar: "#{__dirname}/lib/selenium-server-standalone-2.31.0.jar"
      seleniumServerPort: 4444
      testBrowser: 'chrome'
      testServer: 'localhost'
      testServerPort: 8000
      testFile: '_SpecRunner.html'
      allTestsTimeout: 30 * 60 * 1000    # 30 minutes
      keepalive: false
```

#### options.seleniumJar
- Type: `String`
- Default value: `"#{__dirname}/lib/selenium-server-standalone-2.31.0.jar"`

The location of the selenium standalone server jar.

#### options.seleniumServerPort
- Type: `Number`
- Default value: `4444`

The port number to use for the selenium server.

#### options.testBrowser
- Type: `String`
- Default value: `'chrome'`
- Allowed values: `'chrome', 'firefox', 'internet explorer', ...`
    [source](http://selenium.googlecode.com/svn/trunk/docs/api/py/_modules/selenium/webdriver/common/desired_capabilities.html)

The browser in which the tests will be run.

#### options.testServer
- Type: `String`
- Default value: `'localhost'`

The address of the server where the application is running.

#### options.testServerPort
- Type: `Number`
- Default value: `8000`

The port where the application is running.

#### options.testFile
- Type: `String`
- Default value: `'_SpecRunner.html'`

The file to load that runs the jasmine tests.

#### options.allTestsTimeout
- Type: `Number`
- Default value: `30 * 60 * 1000` (30 minutes)

Time in milliseconds to wait for all of the tests to finish running.

#### options.keepalive
- Type: `Boolean`
- Default value: `false`

When true, the selenium server and browser are not closed after the tests have been run.  Useful for interactive 
debugging of failing tests.

### Output

This task:
- logs the number of tests executed, the number of failed tests, and the full stack traces (Jasmine output)
of any failing tests to the Grunt log.  
- fails if any tests fail.

### Usage Examples

#### Default Options
This task isn't very useful by itself. A usual use case if to configure webdriver_jasmine_runner in a 
grunt.initConfig() call and combine it with other tasks with grunt.registerTask().

In this example, we start a connect server running the app.  The jasmine:build task also creates an appropriate 
_SpecRunner.html file with the specs to be run.

```coffee
grunt.initConfig
    webdriver_jasmine_runner:
        myProject:
            options: {}

grunt.registerTask 'browser:test', ['default', 'jasmine:build', 'connect', 'webdriver_jasmine_runner']
```

## Contributing
Do what you will, but please be careful.

## Release History
0.0.1 - First implementation for use by the Orca team

