# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'runs tests on Heroku CI' do
    app = Hatchet::Runner.new('spring-3-gradle-groovy')

    app.run_ci do |test_run|
      expect(clean_output(test_run.output)).to include('BUILD SUCCESSFUL')
      expect(clean_output(test_run.output)).to match(/DemoApplicationTests/)

      expect(clean_output(test_run.output)).not_to include('UP-TO-DATE')

      test_run.run_again

      expect(clean_output(test_run.output)).to include('BUILD SUCCESSFUL')
      expect(clean_output(test_run.output)).to include('UP-TO-DATE')
    end
  end
end
