# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Gradle buildpack detection' do
  it 'shows helpful error message when no Gradle project files are found' do
    app = Hatchet::Runner.new('non-gradle-app', allow_failure: true)
    app.deploy do
      expect(clean_output(app.output)).to include(<<~OUTPUT)
        remote:  !     Error: Your app is configured to use the Gradle buildpack,
        remote:  !     but we couldn't find any supported Gradle project files.
        remote:  !     
        remote:  !     The Gradle buildpack requires at least one of the following files
        remote:  !     in the root directory of your source code:
        remote:  !     
        remote:  !     Supported Gradle files: gradlew, build.gradle, build.gradle.kts, settings.gradle, settings.gradle.kts
        remote:  !     
        remote:  !     IMPORTANT: If your project uses a different build tool:
        remote:  !     - For Maven projects, use the heroku/java buildpack instead
        remote:  !     - For sbt projects, use the heroku/scala buildpack instead
        remote:  !     
        remote:  !     Currently the root directory of your app contains:
        remote:  !     
        remote:  !     README.md
        remote:  !     
        remote:  !     If your app already has Gradle files, check that they:
        remote:  !     
        remote:  !     1. Are in the top level directory (not a subdirectory).
        remote:  !     2. Have the correct spelling (the filenames are case-sensitive).
        remote:  !     3. Aren't listed in '.gitignore' or '.slugignore'.
        remote:  !     4. Have been added to the Git repository using 'git add --all'
        remote:  !        and then committed using 'git commit'.
        remote:  !     
        remote:  !     For help with using Gradle on Heroku, see:
        remote:  !     https://devcenter.heroku.com/articles/deploying-gradle-apps-on-heroku
      OUTPUT
    end
  end
end
