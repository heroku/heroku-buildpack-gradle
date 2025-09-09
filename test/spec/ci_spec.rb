# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'runs tests on Heroku CI' do
    app = Hatchet::Runner.new('spring-3-gradle-groovy')

    app.run_ci do |test_run|
      # First CI run should build from scratch
      expect(clean_output(test_run.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote:        \\$ \\./gradlew testClasses
        remote:        > Task :compileJava
        remote:        > Task :processResources
        remote:        > Task :classes
        remote:        > Task :compileTestJava
        remote:        > Task :processTestResources NO-SOURCE
        remote:        > Task :testClasses
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        3 actionable tasks: 3 executed
      REGEX

      expect(clean_output(test_run.output)).to match(/DemoApplicationTests/)

      test_run.run_again

      # Second CI run should use cached artifacts
      expect(clean_output(test_run.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote:        \\$ \\./gradlew testClasses
        remote:        > Task :compileJava FROM-CACHE
        remote:        > Task :processResources
        remote:        > Task :classes
        remote:        > Task :compileTestJava FROM-CACHE
        remote:        > Task :processTestResources NO-SOURCE
        remote:        > Task :testClasses
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        3 actionable tasks: 1 executed, 2 from cache
      REGEX
    end
  end
end
