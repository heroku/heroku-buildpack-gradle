# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'fails with a descriptive error message when Gradle wrapper is missing' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy', allow_failure: true)
    app.before_deploy do
      # Remove gradle wrapper to trigger missing wrapper error
      File.delete('gradlew')
      `git add . && git commit -m "remove gradle wrapper"`
    end

    app.deploy do
      expect(clean_output(app.output)).to include(<<~OUTPUT)
        remote:  !     Error: Gradle Wrapper is missing.
        remote:  !     
        remote:  !     The Gradle Wrapper (gradlew) is required to build your application on Heroku.
        remote:  !     This ensures that your application builds with the same version of Gradle
        remote:  !     that you use during development. Projects are required to include
        remote:  !     their own Wrapper for reliable, reproducible builds.
        remote:  !     
        remote:  !     Note: The buildpack used to provide a default Gradle Wrapper (using Gradle 2.0) for
        remote:  !     applications that didn't include their own wrapper. That workaround was deprecated
        remote:  !     in 2014 and has now been removed.
        remote:  !     
        remote:  !     To fix this issue, run this command in your project directory
        remote:  !     locally and commit the generated files:
        remote:  !     $ gradle wrapper
        remote:  !     
        remote:  !     If you don't have Gradle installed locally, you can install it first:
        remote:  !     https://gradle.org/install/
        remote:  !     
        remote:  !     For more information about Gradle Wrapper, see:
        remote:  !     https://docs.gradle.org/current/userguide/gradle_wrapper.html
        remote:  !     https://devcenter.heroku.com/articles/deploying-gradle-apps-on-heroku
      OUTPUT
    end
  end

  it 'fails with a descriptive error message when Gradle daemon fails to start' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy', allow_failure: true)
    app.before_deploy do
      # Corrupt gradle wrapper properties to cause daemon startup failure
      File.write('gradle/wrapper/gradle-wrapper.properties', 'invalid content')
      `git add . && git commit -m "corrupt gradle wrapper properties"`
    end

    app.deploy do
      expect(clean_output(app.output)).to include(<<~OUTPUT)
        remote:  !     Error: Failed to start Gradle daemon.
        remote:  !     
        remote:  !     An error occurred while starting the Gradle daemon. This usually
        remote:  !     indicates an issue with the Gradle wrapper, build configuration,
        remote:  !     or system resources.
        remote:  !     
        remote:  !     Check the output above for specific error messages from Gradle.
        remote:  !     Common causes include:
        remote:  !     
        remote:  !     - Corrupted or missing Gradle wrapper files
        remote:  !     - Invalid Gradle configuration in build.gradle(.kts) or settings.gradle(.kts)
        remote:  !     - Network connectivity issues downloading Gradle dependencies
        remote:  !     - Incompatible Gradle version with the current Java runtime
        remote:  !     
        remote:  !     To resolve this issue:
        remote:  !     1. Verify your Gradle wrapper works locally: ./gradlew --version
        remote:  !     2. Check your build.gradle(.kts) and settings.gradle(.kts) for syntax errors
        remote:  !     3. Ensure you're using a supported Gradle version
        remote:  !     
        remote:  !     If this appears to be a temporary network or download issue,
        remote:  !     try deploying again as it may resolve itself.
        remote:  !     
        remote:  !     For more information, see:
        remote:  !     https://docs.gradle.org/current/userguide/troubleshooting.html
      OUTPUT
    end
  end

  it 'fails with a descriptive error message on a failed build' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy', allow_failure: true)
    app.before_deploy do
      File.write('src/main/java/com/heroku/App.java', <<~JAVA)
        package com.heroku;

        public class App {
            public static void main(String[] args) {
                // Missing semicolon to cause compile error
                System.out.println("Hello World")
            }
        }
      JAVA
      `git add . && git commit -m "introduce compile error"`
    end

    app.deploy do
      expect(clean_output(app.output)).to include(<<~OUTPUT)
        remote:  !     Error: Gradle build failed.
        remote:  !     
        remote:  !     An error occurred during the Gradle build process. This usually
        remote:  !     indicates an issue with your application's dependencies, configuration,
        remote:  !     or source code.
        remote:  !     
        remote:  !     First, check the build output above for specific error messages
        remote:  !     from Gradle that might indicate what went wrong. Common issues include:
        remote:  !     
        remote:  !     - Missing or incompatible dependencies in your build.gradle(.kts)
        remote:  !     - Compilation errors in your application source code
        remote:  !     - Test failures (if tests are enabled during the build)
        remote:  !     - Invalid Gradle configuration or settings
        remote:  !     - Using an incompatible OpenJDK version for your project
        remote:  !     
        remote:  !     To troubleshoot this issue:
        remote:  !     1. Try building your application locally with the same Gradle command
        remote:  !     2. Check that your gradlew script works locally: ./gradlew build
        remote:  !     3. Verify your Java version is compatible with your project
        remote:  !     
        remote:  !     If the error persists, check the documentation:
        remote:  !     https://docs.gradle.org/current/userguide/troubleshooting.html
        remote:  !     https://devcenter.heroku.com/articles/deploying-gradle-apps-on-heroku
      OUTPUT
    end
  end

  it 'fails with a descriptive error message when GRADLE_TASK contains a non-existent task' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy',
                              allow_failure: true,
                              config: { GRADLE_TASK: 'pleasefail -x check' })

    app.deploy do
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote: -----> Gradle app detected
        remote: -----> Installing Azul Zulu OpenJDK 11\\.0\\.28
        remote: -----> Building Gradle app\\.\\.\\.
        remote: -----> executing \\./gradlew pleasefail -x check
        remote:        Downloading https://services\\.gradle\\.org/distributions/gradle-8\\.12-bin\\.zip
        remote:        \\.+10%\\.+20%\\.+30%\\.+40%\\.+50%\\.+60%\\.+70%\\.+80%\\.+90%\\.+100%
        remote:        To honour the JVM settings for this build a single-use Daemon process will be forked\\. For more on this, please refer to https://docs\\.gradle\\.org/8\\.12/userguide/gradle_daemon\\.html#sec:disabling_the_daemon in the Gradle documentation\\.
        remote:        Daemon will be stopped at the end of the build 
        remote:        
        remote:        \\[Incubating\\] Problems report is available at: file:///tmp/build_[a-f0-9]+/build/reports/problems/problems-report\\.html
        remote:        
        remote:        FAILURE: Build failed with an exception\\.
        remote:        
        remote:        \\* What went wrong:
        remote:        Task 'pleasefail' not found in root project 'build_[a-f0-9]+'\\.
        remote:        
        remote:        \\* Try:
        remote:        > Run gradlew tasks to get a list of available tasks\\.
        remote:        > For more on name expansion, please refer to https://docs\\.gradle\\.org/8\\.12/userguide/command_line_interface\\.html#sec:name_abbreviation in the Gradle documentation\\.
        remote:        > Run with --stacktrace option to get the stack trace\\.
        remote:        > Run with --info or --debug option to get more log output\\.
        remote:        > Run with --scan to get full insights\\.
        remote:        > Get more help at https://help\\.gradle\\.org\\.
        remote:        
        remote:        Deprecated Gradle features were used in this build, making it incompatible with Gradle 9\\.0\\.
        remote:        
        remote:        You can use '--warning-mode all' to show the individual deprecation warnings and determine if they come from your own scripts or plugins\\.
        remote:        
        remote:        For more on this, please refer to https://docs\\.gradle\\.org/8\\.12/userguide/command_line_interface\\.html#sec:command_line_warnings in the Gradle documentation\\.
        remote:        
        remote:        BUILD FAILED in [0-9]+s
        remote: 
        remote:  !     ERROR: Failed to run Gradle!
      REGEX
    end
  end

  it 'shows EOL warning for unsupported Gradle version (7.x)' do
    app = Hatchet::Runner.new('simple-http-service-gradle-7-groovy')
    app.deploy do
      expect(clean_output(app.output)).to include(<<~OUTPUT)
        remote:  !     Warning: Unsupported Gradle version detected.
        remote:  !     
        remote:  !     You are using Gradle 7.6.3, which is end-of-life and no longer
        remote:  !     receives security updates or bug fixes.
        remote:  !     
        remote:  !     Please upgrade to Gradle 9 (current) for active support, or at minimum
        remote:  !     Gradle 8 for security fixes only.
        remote:  !     
        remote:  !     This buildpack will attempt to build your application, but compatibility
        remote:  !     with unsupported Gradle versions is not guaranteed and may break in future
        remote:  !     buildpack releases. We strongly recommend upgrading.
        remote:  !     
        remote:  !     For more information:
        remote:  !     - https://docs.gradle.org/current/userguide/feature_lifecycle.html#eol_support
        remote:  !     
        remote:  !     Upgrade guides:
        remote:  !     - https://docs.gradle.org/current/userguide/upgrading_version_7.html
        remote:  !     - https://docs.gradle.org/current/userguide/upgrading_major_version_9.html
      OUTPUT
    end
  end
end
