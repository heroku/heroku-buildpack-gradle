require_relative 'spec_helper'

describe "Gradle" do
  context "on JDK #{DEFAULT_OPENJDK_VERSION}" do
    it "deploys successfully" do
      new_default_hatchet_runner("gradle-kotlin-dsl-sample").tap do |app|
        app.before_deploy do
          set_java_version(DEFAULT_OPENJDK_VERSION)
        end

        app.deploy do
          expect(app.output).not_to include("Ratpack detected")
          expect(app.output).not_to include("Spring Boot detected")
          expect(app.output).not_to include("Spring Boot and Webapp Runner detected")
          expect(app.output).to include("Building Gradle app")
          expect(app.output).to include("executing ./gradlew stage")
          expect(app.output).to include("BUILD SUCCESSFUL")
          expect(http_get(app)).to eq("Hello from Kotlin")
        end
      end
    end
  end

  context "with Spring Boot" do
    it "deploys successfully" do
      new_default_hatchet_runner("spring-boot-gradle-kotlin-dsl").tap do |app|
        app.before_deploy do
          set_java_version(DEFAULT_OPENJDK_VERSION)
        end

        app.deploy do
          expect(app.output).not_to include("Ratpack detected")
          expect(app.output).not_to include("Spring Boot and Webapp Runner detected")
          expect(app.output).to include("Spring Boot detected")
          expect(app.output).to include("Building Gradle app")
          expect(app.output).to include("executing ./gradlew build -x check")
          expect(app.output).to include("BUILD SUCCESSFUL")
          expect(http_get(app)).to eq("Hello from Spring Boot")
        end
      end
    end
  end
end
