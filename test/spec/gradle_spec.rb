require_relative 'spec_helper'

describe "Gradle" do
  it "deploys successfully" do
    new_default_hatchet_runner("gradle-getting-started").tap do |app|
      app.deploy do
        expect(app.output).not_to include("Ratpack detected")
        expect(app.output).to include("Spring Boot detected")
        expect(app.output).not_to include("Spring Boot and Webapp Runner detected")
        expect(app.output).to include("Building Gradle app")
        expect(app.output).not_to include("executing ./gradlew stage")
        expect(app.output).to include("executing ./gradlew build -x check")
        expect(app.output).to include("BUILD SUCCESSFUL")
      end
    end
  end
end
