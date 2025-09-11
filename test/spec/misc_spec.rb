# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'shows deprecation warning and installs Gradle wrapper when missing' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy')
    app.before_deploy do
      # Remove gradle wrapper to trigger wrapper installation
      File.delete('gradlew')
      `git add . && git commit -m "remove gradle wrapper"`
    end

    app.deploy do
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote: -----> Gradle app detected
        remote: -----> Installing Azul Zulu OpenJDK 11\\.0\\.28
        remote: -----> Installing Gradle Wrapper\\.\\.\\.
        remote:        WARNING: Your application does not have it's own gradlew file\\.
        remote:        We'll install one for you, but this is a deprecated feature and
        remote:        in the future may not be supported\\.
        remote: cp: warning: behavior of -n is non-portable and may change in future; use --update=none instead
        remote: -----> Building Gradle app\\.\\.\\.
        remote: -----> executing \\./gradlew stage
        remote:        Downloading https://services\\.gradle\\.org/distributions/gradle-8\\.12-bin\\.zip
        remote:        \\.+10%\\.+20%\\.+30%\\.+40%\\.+50%\\.+60%\\.+70%\\.+80%\\.+90%\\.+100%
        remote:        To honour the JVM settings for this build a single-use Daemon process will be forked\\. For more on this, please refer to https://docs\\.gradle\\.org/8\\.12/userguide/gradle_daemon\\.html#sec:disabling_the_daemon in the Gradle documentation\\.
        remote:        Daemon will be stopped at the end of the build 
        remote:        > Task :compileJava
        remote:        > Task :processResources NO-SOURCE
        remote:        > Task :classes
        remote:        > Task :jar
        remote:        > Task :startScripts
        remote:        > Task :distTar
        remote:        > Task :distZip
        remote:        > Task :assemble
        remote:        > Task :compileTestJava
        remote:        > Task :processTestResources NO-SOURCE
        remote:        > Task :testClasses
        remote:        > Task :test
        remote:        > Task :check
        remote:        > Task :build
        remote:        
        remote:        > Task :buildpackIntegrationEcho
        remote:        
        remote:        \\[BUILDPACK INTEGRATION TEST - GRADLE VERSION\\] 8\\.12
        remote:        \\[BUILDPACK INTEGRATION TEST - JAVA VERSION\\] 11\\.0\\.28
        remote:        \\[BUILDPACK INTEGRATION TEST - JDBC_DATABASE_URL\\] null
        remote:        \\[BUILDPACK INTEGRATION TEST - JDBC_DATABASE_USERNAME\\] null
        remote:        \\[BUILDPACK INTEGRATION TEST - JDBC_DATABASE_PASSWORD\\] null
        remote:        
        remote:        > Task :stage
        remote:        
        remote:        \\[Incubating\\] Problems report is available at: file:///tmp/build_[a-f0-9]+/build/reports/problems/problems-report\\.html
        remote:        
        remote:        Deprecated Gradle features were used in this build, making it incompatible with Gradle 9\\.0\\.
        remote:        
        remote:        You can use '--warning-mode all' to show the individual deprecation warnings and determine if they come from your own scripts or plugins\\.
        remote:        
        remote:        For more on this, please refer to https://docs\\.gradle\\.org/8\\.12/userguide/command_line_interface\\.html#sec:command_line_warnings in the Gradle documentation\\.
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        8 actionable tasks: 8 executed
        remote: -----> Discovering process types
        remote:        Procfile declares types -> web
        remote: 
        remote: -----> Compressing\\.\\.\\.
        remote:        Done: [0-9]+\\.[0-9]+M
        remote: -----> Launching\\.\\.\\.
        remote:        Released v3
        remote:        https://hatchet-t-[a-f0-9]+-[a-f0-9]+\\.herokuapp\\.com/ deployed to Heroku
        remote: 
        remote: Verifying deploy\\.\\.\\. done\\.
      REGEX
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
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote: -----> Gradle app detected
        remote: -----> Installing Azul Zulu OpenJDK 11\\.0\\.28
        remote: -----> Building Gradle app\\.\\.\\.
        remote: -----> executing \\./gradlew stage
        remote:        Exception in thread "main" java\\.lang\\.RuntimeException: Could not load wrapper properties from '/tmp/build_[a-f0-9]+/gradle/wrapper/gradle-wrapper\\.properties'\\.
        remote:            at org\\.gradle\\.wrapper\\.WrapperExecutor\\.<init>\\(WrapperExecutor\\.java:63\\)
        remote:            at org\\.gradle\\.wrapper\\.WrapperExecutor\\.forWrapperPropertiesFile\\(WrapperExecutor\\.java:46\\)
        remote:            at org\\.gradle\\.wrapper\\.GradleWrapperMain\\.main\\(GradleWrapperMain\\.java:62\\)
        remote:        Caused by: java\\.lang\\.RuntimeException: No value with key 'distributionUrl' specified in wrapper properties file '/tmp/build_[a-f0-9]+/gradle/wrapper/gradle-wrapper\\.properties'\\.
        remote:            at org\\.gradle\\.wrapper\\.WrapperExecutor\\.reportMissingProperty\\(WrapperExecutor\\.java:141\\)
        remote:            at org\\.gradle\\.wrapper\\.WrapperExecutor\\.readDistroUrl\\(WrapperExecutor\\.java:80\\)
        remote:            at org\\.gradle\\.wrapper\\.WrapperExecutor\\.prepareDistributionUri\\(WrapperExecutor\\.java:69\\)
        remote:            at org\\.gradle\\.wrapper\\.WrapperExecutor\\.<init>\\(WrapperExecutor\\.java:55\\)
        remote:            \\.\\.\\. 2 more
        remote: 
        remote:  !     ERROR: Failed to run Gradle!
        remote:        We're sorry this build is failing\\. If you can't find the issue in application
        remote:        code, please submit a ticket so we can help: https://help\\.heroku\\.com
        remote:        You can also try reverting to the previous version of the buildpack by running:
        remote:        \\$ heroku buildpacks:set https://github\\.com/heroku/heroku-buildpack-gradle#previous-version
        remote:        
        remote:        Thanks,
        remote:        Heroku
        remote: 
        remote:  !     Push rejected, failed to compile Gradle app\\.
        remote: 
        remote:  !     Push failed
      REGEX
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
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote: -----> Gradle app detected
        remote: -----> Installing Azul Zulu OpenJDK 11\\.0\\.28
        remote: -----> Building Gradle app\\.\\.\\.
        remote: -----> executing \\./gradlew stage
        remote:        Downloading https://services\\.gradle\\.org/distributions/gradle-8\\.12-bin\\.zip
        remote:        \\.+10%\\.+20%\\.+30%\\.+40%\\.+50%\\.+60%\\.+70%\\.+80%\\.+90%\\.+100%
        remote:        To honour the JVM settings for this build a single-use Daemon process will be forked\\. For more on this, please refer to https://docs\\.gradle\\.org/8\\.12/userguide/gradle_daemon\\.html#sec:disabling_the_daemon in the Gradle documentation\\.
        remote:        Daemon will be stopped at the end of the build 
        remote:        
        remote:        > Task :compileJava FAILED
        remote:        /tmp/build_[a-f0-9]+/src/main/java/com/heroku/App\\.java:6: error: ';' expected
        remote:                System\\.out\\.println\\("Hello World"\\)
        remote:                                                 \\^
        remote:        1 error
        remote:        
        remote:        \\[Incubating\\] Problems report is available at: file:///tmp/build_[a-f0-9]+/build/reports/problems/problems-report\\.html
        remote:        
        remote:        FAILURE: Build failed with an exception\\.
        remote:        
        remote:        \\* What went wrong:
        remote:        Execution failed for task ':compileJava'\\.
        remote:        > Compilation failed; see the compiler output below\\.
        remote:          /tmp/build_[a-f0-9]+/src/main/java/com/heroku/App\\.java:6: error: ';' expected
        remote:                  System\\.out\\.println\\("Hello World"\\)
        remote:                                                   \\^
        remote:          1 error
        remote:        
        remote:        \\* Try:
        remote:        > Check your code and dependencies to fix the compilation error\\(s\\)
        remote:        > Run with --scan to get full insights\\.
        remote:        
        remote:        Deprecated Gradle features were used in this build, making it incompatible with Gradle 9\\.0\\.
        remote:        
        remote:        You can use '--warning-mode all' to show the individual deprecation warnings and determine if they come from your own scripts or plugins\\.
        remote:        
        remote:        For more on this, please refer to https://docs\\.gradle\\.org/8\\.12/userguide/command_line_interface\\.html#sec:command_line_warnings in the Gradle documentation\\.
        remote:        
        remote:        BUILD FAILED in [0-9]+s
        remote:        1 actionable task: 1 executed
        remote: 
        remote:  !     ERROR: Failed to run Gradle!
        remote:        We're sorry this build is failing\\. If you can't find the issue in application
        remote:        code, please submit a ticket so we can help: https://help\\.heroku\\.com
        remote:        You can also try reverting to the previous version of the buildpack by running:
        remote:        \\$ heroku buildpacks:set https://github\\.com/heroku/heroku-buildpack-gradle#previous-version
        remote:        
        remote:        Thanks,
        remote:        Heroku
        remote: 
        remote:  !     Push rejected, failed to compile Gradle app\\.
        remote: 
        remote:  !     Push failed
      REGEX
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

  it 'can build and run apps with older Gradle version (7.x)' do
    app = Hatchet::Runner.new('simple-http-service-gradle-7-groovy')
    app.deploy do
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote: -----> Gradle app detected
        remote: -----> Installing Azul Zulu OpenJDK 11\\.0\\.28
        remote: -----> Building Gradle app\\.\\.\\.
        remote: -----> executing \\./gradlew stage
        remote:        Downloading https://services\\.gradle\\.org/distributions/gradle-7\\.6\\.3-bin\\.zip
        remote:        \\.+10%\\.+20%\\.+30%\\.+40%\\.+50%\\.+60%\\.+70%\\.+80%\\.+90%\\.+100%
        remote:        To honour the JVM settings for this build a single-use Daemon process will be forked\\. See https://docs\\.gradle\\.org/7\\.6\\.3/userguide/gradle_daemon\\.html#sec:disabling_the_daemon\\.
        remote:        Daemon will be stopped at the end of the build 
        remote:        > Task :compileJava
        remote:        > Task :processResources NO-SOURCE
        remote:        > Task :classes
        remote:        > Task :jar
        remote:        > Task :startScripts
        remote:        > Task :distTar
        remote:        > Task :distZip
        remote:        > Task :assemble
        remote:        > Task :compileTestJava
        remote:        > Task :processTestResources NO-SOURCE
        remote:        > Task :testClasses
        remote:        > Task :test
        remote:        > Task :check
        remote:        > Task :build
        remote:        
        remote:        > Task :buildpackIntegrationEcho
        remote:        
        remote:        \\[BUILDPACK INTEGRATION TEST - GRADLE VERSION\\] 7\\.6\\.3
        remote:        \\[BUILDPACK INTEGRATION TEST - JAVA VERSION\\] 11\\.0\\.28
        remote:        \\[BUILDPACK INTEGRATION TEST - JDBC_DATABASE_URL\\] null
        remote:        \\[BUILDPACK INTEGRATION TEST - JDBC_DATABASE_USERNAME\\] null
        remote:        \\[BUILDPACK INTEGRATION TEST - JDBC_DATABASE_PASSWORD\\] null
        remote:        
        remote:        > Task :stage
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        8 actionable tasks: 8 executed
        remote: -----> Discovering process types
        remote:        Procfile declares types -> web
        remote: 
        remote: -----> Compressing\\.\\.\\.
        remote:        Done: [0-9]+\\.[0-9]+M
        remote: -----> Launching\\.\\.\\.
        remote:        Released v3
        remote:        https://hatchet-t-[a-f0-9]+-[a-f0-9]+\\.herokuapp\\.com/ deployed to Heroku
        remote: 
        remote: Verifying deploy\\.\\.\\. done\\.
      REGEX
    end
  end
end
