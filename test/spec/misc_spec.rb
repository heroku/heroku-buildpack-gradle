# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'fails with a descriptive error message when Gradle daemon fails to start' do
    app = Hatchet::Runner.new('simple-http-service', allow_failure: true)
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
        remote:  !     - Invalid Gradle configuration in build.gradle or settings.gradle
        remote:  !     - Insufficient memory or disk space
        remote:  !     - Network connectivity issues downloading Gradle dependencies
        remote:  !     - Incompatible Gradle version with the current Java runtime
        remote:  !     
        remote:  !     Try building your application locally with the same Gradle version
        remote:  !     to reproduce and debug the issue.
      OUTPUT
    end
  end

  it 'fails with a descriptive error message on a failed build' do
    app = Hatchet::Runner.new('simple-http-service', allow_failure: true)
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
        remote:  !     - Missing or incompatible dependencies in your build.gradle
        remote:  !     - Compilation errors in your application source code
        remote:  !     - Test failures (if tests are enabled during the build)
        remote:  !     - Invalid Gradle configuration or settings
        remote:  !     - Using an incompatible OpenJDK version for your project
        remote:  !     
        remote:  !     If you're unable to determine the cause from the Gradle output,
        remote:  !     try building your application locally with the same Gradle command
        remote:  !     to reproduce and debug the issue.
      OUTPUT
    end
  end

  it 'succeeds when GRADLE_TASK is set to a custom task' do
    app = Hatchet::Runner.new('simple-http-service', config: { GRADLE_TASK: 'pleasefail -x check' })

    app.deploy do
      expect(app.output).to include('BUILD SUCCESSFUL')
    end
  end
end
