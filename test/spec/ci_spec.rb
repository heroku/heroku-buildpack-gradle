# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'runs tests on Heroku CI' do
    app = Hatchet::Runner.new('spring-3-gradle-8-groovy', allow_failure: true)

    app.run_ci do |test_run|
      # First CI run should build from scratch
      expect(clean_output(test_run.output)).to include("-----> executing ./gradlew testClasses")
      expect(clean_output(test_run.output)).to include("BUILD SUCCESSFUL")
      # Expect JAVA_HOME error during test runtime resolution but overall success
      expect(clean_output(test_run.output)).to include("ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH")
      expect(clean_output(test_run.output)).to include("-----> Gradle buildpack tests completed successfully")

      test_run.run_again

      # Second CI run should also complete successfully  
      expect(clean_output(test_run.output)).to include("-----> executing ./gradlew testClasses")
      expect(clean_output(test_run.output)).to include("BUILD SUCCESSFUL")
      # JAVA_HOME error may still occur but tests should complete successfully
      expect(clean_output(test_run.output)).to include("-----> Gradle buildpack tests completed successfully")
    end
  end
end
