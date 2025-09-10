# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'runs tests on Heroku CI' do
    app = Hatchet::Runner.new('spring-3-gradle-groovy')

    app.run_ci do |test_run|
      # First CI run should build from scratch
      expect(clean_output(test_run.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        -----> Gradle app detected
        -----> Installing Azul Zulu OpenJDK \\d+\\.\\d+\\.\\d+
        -----> Starting Gradle daemon
        -----> Executing Gradle
               \\$ \\./gradlew testClasses
               > Task :compileJava
               > Task :processResources
               > Task :classes
               > Task :compileTestJava
               > Task :processTestResources NO-SOURCE
               > Task :testClasses
               
               BUILD SUCCESSFUL in \\d+s
               3 actionable tasks: 3 executed
        -----> Stopping Gradle daemon
        -----> Resolving test runtime dependencies
               Starting a Gradle Daemon, \\d+ stopped Daemon could not be reused, use --status for details
               > Task :resolveTestRuntime
               
               BUILD SUCCESSFUL in \\d+s
               1 actionable task: 1 executed
        -----> No test-setup command provided\\. Skipping\\.
        -----> Running Gradle buildpack tests...
        Picked up JAVA_TOOL_OPTIONS: -Dfile\\.encoding=UTF-8 -XX:MaxRAM=2684354560 -XX:MaxRAMPercentage=80\\.0
        To honour the JVM settings for this build a single-use Daemon process will be forked\\. For more on this, please refer to https://docs\\.gradle\\.org/[\\d\\.]+/userguide/gradle_daemon\\.html#sec:disabling_the_daemon in the Gradle documentation\\.
        Daemon will be stopped at the end of the build 
        > Task :compileJava UP-TO-DATE
        > Task :processResources
        > Task :classes
        > Task :compileTestJava UP-TO-DATE
        > Task :processTestResources NO-SOURCE
        > Task :testClasses UP-TO-DATE
        
        > Task :test
        Picked up JAVA_TOOL_OPTIONS: -Dfile\\.encoding=UTF-8 -XX:MaxRAM=2684354560 -XX:MaxRAMPercentage=80\\.0
        
        OpenJDK 64-Bit Server VM warning: Sharing is only supported for boot loader classes because bootstrap classpath has been appended
        
        > Task :check
        
        BUILD SUCCESSFUL in \\d+s
        \\d+ actionable tasks: \\d+ executed, \\d+ up-to-date
        -----> Gradle buildpack tests completed successfully
      REGEX

      test_run.run_again

      # Second CI run should use cached artifacts
      expect(clean_output(test_run.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        -----> Gradle app detected
        -----> Installing Azul Zulu OpenJDK \\d+\\.\\d+\\.\\d+
        -----> Starting Gradle daemon
        -----> Executing Gradle
               \\$ \\./gradlew testClasses
               > Task :compileJava FROM-CACHE
               > Task :processResources
               > Task :classes
               > Task :compileTestJava FROM-CACHE
               > Task :processTestResources NO-SOURCE
               > Task :testClasses UP-TO-DATE
               
               BUILD SUCCESSFUL in \\d+s
               3 actionable tasks: 1 executed, 2 from cache
        -----> Stopping Gradle daemon
        -----> Resolving test runtime dependencies
               Starting a Gradle Daemon, \\d+ stopped Daemon could not be reused, use --status for details
               > Task :resolveTestRuntime
               
               BUILD SUCCESSFUL in \\d+s
               1 actionable task: 1 executed
        -----> No test-setup command provided\\. Skipping\\.
        -----> Running Gradle buildpack tests...
        Picked up JAVA_TOOL_OPTIONS: -Dfile\\.encoding=UTF-8 -XX:MaxRAM=2684354560 -XX:MaxRAMPercentage=80\\.0
        To honour the JVM settings for this build a single-use Daemon process will be forked\\. For more on this, please refer to https://docs\\.gradle\\.org/[\\d\\.]+/userguide/gradle_daemon\\.html#sec:disabling_the_daemon in the Gradle documentation\\.
        Daemon will be stopped at the end of the build 
        > Task :compileJava UP-TO-DATE
        > Task :processResources
        > Task :classes
        > Task :compileTestJava UP-TO-DATE
        > Task :processTestResources NO-SOURCE
        > Task :testClasses UP-TO-DATE
        
        > Task :test
        Picked up JAVA_TOOL_OPTIONS: -Dfile\\.encoding=UTF-8 -XX:MaxRAM=2684354560 -XX:MaxRAMPercentage=80\\.0
        
        OpenJDK 64-Bit Server VM warning: Sharing is only supported for boot loader classes because bootstrap classpath has been appended
        
        > Task :check
        
        BUILD SUCCESSFUL in \\d+s
        \\d+ actionable tasks: \\d+ executed, \\d+ up-to-date
        -----> Gradle buildpack tests completed successfully
      REGEX
    end
  end
end
