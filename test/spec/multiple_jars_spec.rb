# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'works with Spring Boot app that duplicates JARs' do
    app = Hatchet::Runner.new('spring-3-gradle-8-kotlin')

    # Add the duplicate-jars task to the build script
    app.before_deploy do
      build_gradle_content = File.read('build.gradle.kts')

      additional_tasks = <<~KOTLIN

        tasks.build {
        	finalizedBy("duplicate-jars")
        }

        tasks.register<Copy>("duplicate-jars") {
        	into(layout.buildDirectory.dir("libs"))
        	with(copySpec {
        		from(layout.buildDirectory.dir("libs"))
        		include("*.jar")
        		rename("\\\\.jar", "-additional.jar")
        	})
        }
      KOTLIN

      File.write('build.gradle.kts', build_gradle_content + additional_tasks)
    end

    app.deploy do
      expect(app.output).to include('BUILD SUCCESSFUL')
      expect(app.output).to include('> Task :duplicate-jars')
      expect(successful_body(app)).to include('Hello Heroku!')
    end
  end
end
