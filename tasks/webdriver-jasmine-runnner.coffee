
module.exports = (grunt) ->
  'use strict';

  fs = require 'fs';

  webdriver = require 'selenium-webdriver'
  remote = require 'selenium-webdriver/remote'

  grunt.registerMultiTask 'webdriver_jasmine_runner', 'Runs a jasmine test with webdriver.', ->

    options = @options
      seleniumJar: __dirname+'/lib/selenium-server-standalone-2.31.0.jar'
      seleniumServerPort: 4444
      testBrowser: 'chrome'
      testServer: 'localhost'
      testServerPort: 8000
      testFile: '_SpecRunner.html'

    if not fs.existsSync options.seleniumJar
      throw Error "The specified jar does not exist: #{options.seleniumJar}"

    server = new remote.SeleniumServer
      jar: options.seleniumJar
      port: options.seleniumServerPort

    server.start();

    done = @async()

    server.address().then (serverAddress) ->
        driver = new webdriver.Builder()
          .usingServer(serverAddress)
          .withCapabilities({'browserName': options.testBrowser})
          .build()

        testUrl = "http://#{options.testServer}:#{options.testServerPort}/#{options.testFile}"

        driver.session_.then (sessionData) ->
            htmlReporterElement = null
            runJasmineTests = webdriver.promise.createFlow (flow)->
              flow.execute ->
                driver.get("#{testUrl}?wdurl=#{encodeURIComponent(serverAddress)}&wdsid=#{sessionData.id}").then ->


              flow.execute ->
                elementFound = false

                driver.wait ->
                  driver.getTitle().then (title)->
                    !!title
                , 5000

                driver.findElement(webdriver.By.id('HTMLReporter')).then (elem) ->
                  elementFound = true
                  htmlReporterElement = elem

              flow.execute ->
                htmlReporterElement.getText().then (elemText) ->
                  console.log elemText

            runJasmineTests.then ->
              driver.quit().addBoth ->
                  server.stop()
                  done()
