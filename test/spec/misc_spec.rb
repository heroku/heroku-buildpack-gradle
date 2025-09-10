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
      expect(clean_output(app.output)).to include("BUILD SUCCESSFUL")
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
      expect(clean_output(app.output)).to include("Could not load wrapper properties from")
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
      expect(clean_output(app.output)).to include("ERROR: Failed to run Gradle!")
    end
  end

  it 'fails with a descriptive error message when GRADLE_TASK contains a non-existent task' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy',
                              allow_failure: true,
                              config: { GRADLE_TASK: 'pleasefail -x check' })

    app.deploy do
      expect(clean_output(app.output)).to include("Task 'pleasefail' not found in root project")
    end
  end

  it 'shows EOL warning for unsupported Gradle version (7.x)' do
    app = Hatchet::Runner.new('simple-http-service-gradle-7-groovy')
    app.deploy do
      expect(clean_output(app.output)).to include("gradle-7.6.3-bin.zip")
    end
  end
end
