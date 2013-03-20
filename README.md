# grunt-webdriver-jasmine-runnner

> A grunt plugin that runs jasmine tests using webdriver.

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins.
Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install git+ssh://github.com/RallySoftware/grunt-webdriver-jasmine-runner.git
```

You will probably need to enter your github credentials to complete the installation

The module can also be installed with package.json by adding the following:

```js
{
    "name": "your-app-name",
    "version": "99.99.99",
    "devDependencies": {
        "private-repo": "https://github.com/RallySoftware/grunt-webdriver-jasmine-runner.git"
    }
}
```

One the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-webdriver-jasmine-runnner');
```

## The "webdriver_jasmine_runnner" task

### Overview
In your project's Gruntfile, add a section named `webdriver_jasmine_runnner` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  webdriver_jasmine_runnner: {
    options: {
      // Task-specific options go here.
    },
    your_target: {
      // Target-specific file lists and/or options go here.
    },
  },
})
```

### Options

      seleniumJar: __dirname+'/lib/selenium-server-standalone-2.31.0.jar'
      seleniumServerPort: 4444
      testBrowser: 'chrome'
      testServer: 'localhost'
      testServerPort: 8000
      testFile: '_SpecRunner.html'
      allTestsTimeout: 30 * 60 * 1000
      keepalive: false


#### options.seleniumJar
- Type: `String`
- Default value: `__dirname + '/lib/selenium-server-standalone-2.31.0.jar'`

The location of the selenium standalone server jar.

#### options.seleniumServerPort
- Type: `Number`
- Default value: `4444`

The port number to use for the selenium server.

#### options.testBrowser
- Type: `String`
- Default value: `'chrome'`
- AllowedValues: `'chrome', 'firefox', ...`

The browser to be used to run the tests.

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

Time in milliseconds to wait for the tests to complete.

#### options.keepalive
- Type: `Boolean`
- Default value: `false`

When true, the selenium server and browser are not closed after the tests have been run (for debugging).

### Usage Examples

#### Default Options
This task isn't very useful by itself. A usual use case if to configure webdriver_jasmine_runner in s grunt.initConfig() call and
combine it with other tasks with grunt.registerTask()

```coffee
grunt.initConfig
    webdriver_jasmine_runner:
        orca:
            options:
                keepalive: true

grunt.registerTask 'browser:test', ['default', 'jasmine:orca:build', 'connect', 'webdriver_jasmine_runner']
```

## Contributing
Do what you will, but please be careful.

## Release History
0.0.1 - First implementation for use by the Orca team
