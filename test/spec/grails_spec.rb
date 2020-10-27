require_relative 'spec_helper'


describe "Grails" do
  context "on JDK #{DEFAULT_OPENJDK_VERSION}" do
    it "deploys successfully" do
      new_default_hatchet_runner("grails3-example").tap do |app|
        app.before_deploy do
          set_java_version(DEFAULT_OPENJDK_VERSION)
        end

        app.deploy do
          expect(app.output).to include("Building Gradle app")
          expect(app.output).to include("executing ./gradlew stage")
          expect(app.output).to include("BUILD SUCCESSFUL")
          expect(http_get(app)).to include("Welcome to Grails")
        end
      end
    end
  end
end
