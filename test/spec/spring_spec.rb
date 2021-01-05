require_relative 'spec_helper'


describe "Spring" do
  context "on JDK #{DEFAULT_OPENJDK_VERSION}" do
    it "deploy twice" do
      new_default_hatchet_runner("spring-boot-gradle").tap do |app|
        app.before_deploy do
          set_java_version(DEFAULT_OPENJDK_VERSION)
        end

        app.deploy do
          expect(app.output).to include("Spring Boot detected")
          expect(app.output).to include("Building Gradle app")
          expect(app.output).to include("executing ./gradlew build -x check")
          expect(app.output).to include("Downloading https://services.gradle.org/distributions/gradle-")
          expect(app.output).not_to include(":test")
          expect(app.output).to include("BUILD SUCCESSFUL")
          expect(http_get(app)).to eq("Hello from Spring Boot")

          # make sure the cache has time to update
          sleep 10
          app.commit!
          app.push!

          expect(app.output).to include("Spring Boot detected")
          expect(app.output).to include("Building Gradle app")
          expect(app.output).to include("executing ./gradlew build -x check")
          expect(app.output).not_to include("Downloading https://services.gradle.org/distributions/gradle-")
          expect(app.output).not_to include(":test")
          expect(app.output).to include("BUILD SUCCESSFUL")
          expect(http_get(app)).to eq("Hello from Spring Boot")
        end
      end
    end
  end
end
