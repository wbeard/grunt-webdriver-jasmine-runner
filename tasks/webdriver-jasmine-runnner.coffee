
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
      allTestsTimeout: 30 * 60 * 1000
      keepalive: false

    if not fs.existsSync options.seleniumJar
      throw Error "The specified jar does not exist: #{options.seleniumJar}"

    # TODO Make sure that you can run against a remote selenium server rather than starting your own
    server = new remote.SeleniumServer
      jar: options.seleniumJar
      port: options.seleniumServerPort
    grunt.log.writeln "Starting webdriver server at http://localhost:#{options.seleniumServerPort}"
    server.start();

    done = @async()

    server.address().then (serverAddress) ->
        driver = new webdriver.Builder()
          .usingServer(serverAddress)
          .withCapabilities({'browserName': options.testBrowser})
          .build()

        grunt.log.writeln "Connecting to webdriver server at #{serverAddress}."

        testUrl = "http://#{options.testServer}:#{options.testServerPort}/#{options.testFile}"

        grunt.log.writeln "Running Jasmine tests at #{testUrl} with #{options.testBrowser}."

        allTestsPassed = false

        driver.session_.then (sessionData) ->

          runJasmineTests = webdriver.promise.createFlow (flow)->
            flow.execute ->
              driver.get("#{testUrl}?wdurl=#{encodeURIComponent(serverAddress)}&wdsid=#{sessionData.id}&useWebdriver=true").then ->
                driver.wait ->
                  driver.isElementPresent(webdriver.By.className('symbolSummary')).then (symbolSummaryFound)->
                    symbolSummaryFound
                , 5000
                driver.findElement(webdriver.By.className('symbolSummary')).then (symbolSummaryElement) ->
                  symbolSummaryElement.findElements(webdriver.By.tagName('li')).then (symbolSummaryIcons) ->
                    numTests = symbolSummaryIcons.length
                    grunt.log.writeln 'Test page loaded.  Running ' + "#{numTests}".cyan + ' tests...'
                    driver.wait ->
                      symbolSummaryElement.isElementPresent(webdriver.By.className('pending')).then (isPendingPresent)->
                        !isPendingPresent
                    , options.allTestsTimeout
                    driver.wait ->
                      driver.isElementPresent(webdriver.By.id('details')).then (isPresent) ->
                        isPresent
                    , 6000
                    driver.findElement(webdriver.By.id('details')).then (detailsElement) ->
                      grunt.log.writeln 'Done running all tests.'
                      detailsElement.isElementPresent(webdriver.By.className('failed')).then (hasFailures) ->
                        if (hasFailures)
                          detailsElement.findElements(webdriver.By.className('failed')).then (failedElements) ->
                            grunt.log.writeln "#{failedElements.length} of #{numTests} tests failed:".red
                            for failedElement in failedElements
                              failedElement.getText().then (failureText) ->
                                  grunt.log.writeln failureText.yellow
                        else
                          allTestsPassed = true
                          grunt.log.writeln 'All ' + "#{numTests}".cyan + ' tests passed!'

          runJasmineTests.then ->
            if (!options.keepalive)
              grunt.log.writeln 'Closing test servers.'
              driver.quit().addBoth ->
                server.stop()
                done(allTestsPassed)
