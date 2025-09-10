# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'can build and run Micronaut app with Kotlin DSL build script' do
    app = Hatchet::Runner.new('micronaut-4-gradle-8-kotlin')
    app.deploy do
      # Should detect Micronaut and run shadowJar -x check by default
      expect(app.output).to include('$ ./gradlew shadowJar -x check')
      expect(app.output).to include('BUILD SUCCESSFUL')

      expect(successful_body(app)).to include('Hello Heroku!')
    end
  end
end
