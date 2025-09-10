# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'can build and run Ratpack app with Groovy DSL build script' do
    app = Hatchet::Runner.new('ratpack-2-gradle-9-groovy')
    app.deploy do
      # Should detect Ratpack and run installDist -x check by default
      expect(app.output).to include('-----> executing ./gradlew installDist -x check')
      expect(app.output).to include('BUILD SUCCESSFUL')

      expect(successful_body(app)).to include('Hello Heroku!')
    end
  end
end
