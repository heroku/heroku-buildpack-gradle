require_relative 'spec_helper'


describe "Ratpack" do
  context "on JDK #{DEFAULT_OPENJDK_VERSION}" do
    it "deploys successfully" do
      new_default_hatchet_runner("example-ratpack-gradle-groovy-app").tap do |app|
        app.before_deploy do
          set_java_version(DEFAULT_OPENJDK_VERSION)
        end

        app.deploy do
          expect(app.output).to include("Ratpack detected")
          expect(app.output).to include("Building Gradle app")
          expect(app.output).to include("executing ./gradlew installDist -x check")
          expect(app.output).not_to include(":test")
          expect(app.output).to include("BUILD SUCCESSFUL")
          expect(http_get(app)).to include("Groovy Web Console")
        end
      end
    end
  end
end
