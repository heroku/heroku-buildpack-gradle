# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'caches compiled artifacts between builds with Groovy DSL' do
    app = Hatchet::Runner.new('spring-3-gradle-8-groovy')
    app.deploy do
      # First build should compile everything from scratch
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote:        \\$ \\./gradlew build -x check
        remote:        > Task :compileJava
        remote:        > Task :processResources
        remote:        > Task :classes
        remote:        > Task :resolveMainClassName
        remote:        > Task :bootJar
        remote:        > Task :jar
        remote:        > Task :assemble
        remote:        > Task :build
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        5 actionable tasks: 5 executed
      REGEX

      app.commit!
      app.push!

      # Second build should show FROM-CACHE for cached tasks
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote:        \\$ \\./gradlew build -x check
        remote:        > Task :compileJava FROM-CACHE
        remote:        > Task :processResources
        remote:        > Task :classes
        remote:        > Task :resolveMainClassName
        remote:        > Task :bootJar
        remote:        > Task :jar
        remote:        > Task :assemble
        remote:        > Task :build
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        5 actionable tasks: 4 executed, 1 from cache
      REGEX
    end
  end

  it 'caches compiled artifacts between builds with Kotlin DSL' do
    app = Hatchet::Runner.new('spring-3-gradle-8-kotlin')
    app.deploy do
      # First build should compile everything from scratch
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote:        \\$ \\./gradlew build -x check
        remote:        > Task :compileJava
        remote:        > Task :processResources
        remote:        > Task :classes
        remote:        > Task :resolveMainClassName
        remote:        > Task :bootJar
        remote:        > Task :jar
        remote:        > Task :assemble
        remote:        > Task :build
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        5 actionable tasks: 5 executed
      REGEX

      app.commit!
      app.push!

      # Second build should show FROM-CACHE for cached tasks
      expect(clean_output(app.output)).to match(Regexp.new(<<~REGEX, Regexp::MULTILINE))
        remote:        \\$ \\./gradlew build -x check
        remote:        > Task :compileJava FROM-CACHE
        remote:        > Task :processResources
        remote:        > Task :classes
        remote:        > Task :resolveMainClassName
        remote:        > Task :bootJar
        remote:        > Task :jar
        remote:        > Task :assemble
        remote:        > Task :build
        remote:        
        remote:        BUILD SUCCESSFUL in [0-9]+s
        remote:        5 actionable tasks: 4 executed, 1 from cache
      REGEX
    end
  end
end
