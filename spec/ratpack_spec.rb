require_relative 'spec_helper'

describe "Ratpack" do

  before(:each) do
    init_app(app)
  end

  context "on JDK 8" do
    let(:app) { Hatchet::Runner.new("example-ratpack-gradle-groovy-app") }
    let(:jdk_version) { "1.8" }

    it "deploys successfully" do
      app.deploy do |app|
        expect(app.output).to include("Ratpack detected")
        expect(app.output).to include("Building Gradle app")
        expect(app.output).to include("executing ./gradlew installDist -x test")
        expect(app.output).not_to include(":test")
        expect(app.output).to include("BUILD SUCCESSFUL")
        expect(successful_body(app)).to include("Groovy Web Console")
      end
    end
  end
end
