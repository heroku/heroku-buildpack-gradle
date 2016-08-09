require_relative 'spec_helper'

describe "Gradle" do

  before(:each) do
    init_app(app)
  end

  context "on JDK 8" do
    let(:app) { Hatchet::Runner.new("gradle-getting-started") }
    let(:jdk_version) { "1.8" }

    it "deploys successfully" do
      app.deploy do |app|
        expect(app.output).not_to include("Ratpack detected")
        expect(app.output).not_to include("Spring Boot detected")
        expect(app.output).not_to include("Spring Boot and Webapp Runner detected")
        expect(app.output).to include("Building Gradle app")
        expect(app.output).to include("executing ./gradlew stage")
        expect(app.output).to include("BUILD SUCCESSFUL")
      end
    end
  end
end
