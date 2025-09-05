# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'can build and run Heroku\'s Gradle getting started app' do
    app = Hatchet::Runner.new('gradle-getting-started')
    app.deploy do
      expect(successful_body(app)).to include('Getting Started')
    end
  end
end
