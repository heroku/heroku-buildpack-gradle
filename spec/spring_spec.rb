require_relative 'spec_helper'

describe "Spring" do

  before(:each) do
    init_app(app)
  end

  context "on JDK 8" do
    let(:app) { Hatchet::Runner.new("spring-boot-gradle") }
    let(:jdk_version) { "1.8" }

    it "deploy twice" do
      app.deploy do |app|
        expect(app.output).to include("Spring Boot detected")
        expect(app.output).to include("Building Gradle app")
        expect(app.output).to include("executing ./gradlew build -x test")
        expect(app.output).to include("Downloading https://services.gradle.org/distributions/gradle-")
        expect(app.output).not_to include(":test")
        expect(app.output).to include("BUILD SUCCESSFUL")
        expect(successful_body(app)).to eq("Hello from Spring Boot")

        sleep 10 # make sure the cache has time to update
        `git commit -am "redeploy" --allow-empty`
        app.push!
        expect(app.output).to include("Spring Boot detected")
        expect(app.output).to include("Building Gradle app")
        expect(app.output).to include("executing ./gradlew build -x test")
        expect(app.output).not_to include("Downloading https://services.gradle.org/distributions/gradle-")
        expect(app.output).not_to include(":test")
        expect(app.output).to include("BUILD SUCCESSFUL")
        expect(successful_body(app)).to eq("Hello from Spring Boot")
      end
    end
  end
end
