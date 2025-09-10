# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'can build and run Quarkus app with Kotlin DSL build script' do
    app = Hatchet::Runner.new('quarkus-3-gradle-9-kotlin')
    app.deploy do
      # Should detect Quarkus and run build -x check by default
      expect(app.output).to include('-----> executing ./gradlew build -x check')
      expect(app.output).to include('BUILD SUCCESSFUL')

      expect(successful_body(app)).to include('Hello Heroku!')
    end
  end
end
