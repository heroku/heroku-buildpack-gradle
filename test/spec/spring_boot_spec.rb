# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'can build and run Spring Boot app with Groovy DSL build script' do
    app = Hatchet::Runner.new('spring-3-gradle-8-groovy')
    app.deploy do
      # Should detect Spring Boot and run build -x check by default
      expect(app.output).to include('$ ./gradlew build -x check')
      expect(app.output).to include('BUILD SUCCESSFUL')

      expect(successful_body(app)).to include('Hello Heroku!')
    end
  end

  it 'can build and run Spring Boot app with Kotlin DSL build script' do
    app = Hatchet::Runner.new('spring-3-gradle-8-kotlin')
    app.deploy do
      # Should detect Spring Boot and run build -x check by default
      expect(app.output).to include('$ ./gradlew build -x check')
      expect(app.output).to include('BUILD SUCCESSFUL')

      expect(successful_body(app)).to include('Hello Heroku!')
    end
  end
end
