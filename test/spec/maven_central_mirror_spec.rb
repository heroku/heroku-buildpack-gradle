# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack' do
  # Gradle only logs repository URLs with --info.
  it 'resolves Maven Central artifacts from the Google mirror by default' do
    app = Hatchet::Runner.new('simple-http-service-gradle-8-groovy', config: { GRADLE_TASK: 'stage --info' })
    app.deploy do
      expect(clean_output(app.output)).to include('https://maven-central.storage-download.googleapis.com/maven2/')
      expect(clean_output(app.output)).not_to include('https://repo.maven.apache.org/maven2/')
    end
  end

  # Maven Central rate limiting can fail this build, so it only checks which repository was requested.
  it 'resolves Maven Central artifacts from Maven Central when MAVEN_CENTRAL_MIRROR is false' do
    app = Hatchet::Runner.new(
      'simple-http-service-gradle-8-groovy',
      config: { GRADLE_TASK: 'stage --info', MAVEN_CENTRAL_MIRROR: 'false' },
      allow_failure: true
    )
    app.deploy do
      expect(clean_output(app.output)).to include('https://repo.maven.apache.org/maven2/')
      expect(clean_output(app.output)).not_to include('https://maven-central.storage-download.googleapis.com')
    end
  end
end
