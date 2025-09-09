# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  it 'caches compiled artifacts between builds with Groovy DSL' do
    app = Hatchet::Runner.new('spring-3-gradle-groovy')
    app.deploy do
      # First build should compile everything
      expect(app.output).to include('BUILD SUCCESSFUL')
      expect(app.output).not_to include('UP-TO-DATE')

      app.commit!
      app.push!

      # Second build should show UP-TO-DATE for cached tasks
      expect(app.output).to include('BUILD SUCCESSFUL')
      expect(app.output).to include('UP-TO-DATE')
    end
  end

  it 'caches compiled artifacts between builds with Kotlin DSL' do
    app = Hatchet::Runner.new('spring-3-gradle-kotlin')
    app.deploy do
      # First build should compile everything
      expect(app.output).to include('BUILD SUCCESSFUL')
      expect(app.output).not_to include('UP-TO-DATE')

      app.commit!
      app.push!

      # Second build should show UP-TO-DATE for cached tasks
      expect(app.output).to include('BUILD SUCCESSFUL')
      expect(app.output).to include('UP-TO-DATE')
    end
  end
end
