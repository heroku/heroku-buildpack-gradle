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
      expect(clean_output(app.output)).to include(<<~OUTPUT)
        remote:  !     Error: Gradle task 'pleasefail' not found.
        remote:  !
        remote:  !     The specified Gradle task 'pleasefail' does not exist in your project.
        remote:  !     This can happen when:
        remote:  !
        remote:  !     - The task name is misspelled
        remote:  !     - The task is defined in a plugin that hasn't been applied
        remote:  !     - The task is only available in certain project configurations
        remote:  !     - You're trying to run a task that doesn't exist in this project
        remote:  !
        remote:  !     To see all available tasks in your project, run locally:
        remote:  !     $ ./gradlew tasks
        remote:  !
        remote:  !     To see all tasks including those from plugins, run:
        remote:  !     $ ./gradlew tasks --all
        remote:  !
        remote:  !     If you're setting GRADLE_TASK as an environment variable, make sure
        remote:  !     it contains a valid task name for your project.
        remote:  !
        remote:  !     For more information about Gradle tasks, see:
        remote:  !     https://docs.gradle.org/current/userguide/more_about_tasks.html
      OUTPUT
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

  it 'builds successfully when user enables file system watching via gradle.properties' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy')
    app.before_deploy do
      File.write('gradle.properties', <<~PROPERTIES)
        org.gradle.vfs.watch=true
      PROPERTIES
      `git add . && git commit -m "enable file system watching"`
    end

    app.deploy do
      expect(app).to be_deployed
      expect(clean_output(app.output)).not_to include(
        'Enabling file system watching via --watch-fs (or via the org.gradle.vfs.watch property) ' \
        'with --project-cache-dir also specified is not supported; remove either option to fix this problem'
      )
    end
  end

  it 'uses stage task (with description) when available' do
    app = Hatchet::Runner.new('spring-3-gradle-8-groovy')
    app.before_deploy do
      stage_task = <<~GROOVY
        task stage {
            description = 'Custom stage task for deployment'
            dependsOn build
        }
      GROOVY

      File.write('build.gradle', "#{File.read('build.gradle')}\n#{stage_task}")
    end

    app.deploy do
      expect(app).to be_deployed
      expect(clean_output(app.output)).to include('$ ./gradlew stage')
    end
  end

  it 'uses stage task (without description) when available' do
    app = Hatchet::Runner.new('spring-3-gradle-8-groovy')
    app.before_deploy do
      stage_task = <<~GROOVY
        task stage {
            dependsOn build
        }
      GROOVY

      File.write('build.gradle', "#{File.read('build.gradle')}\n#{stage_task}")
    end

    app.deploy do
      expect(app).to be_deployed
      expect(clean_output(app.output)).to include('$ ./gradlew stage')
    end
  end
end
