require_relative 'spec_helper'

describe "Grails" do

  before(:each) do
    init_app(app)
  end

  context "on JDK 8" do
    let(:app) { Hatchet::Runner.new("grails3-example") }
    let(:jdk_version) { "1.8" }

    it "deploys successfully" do
      app.deploy do |app|
        expect(app.output).to include("Building Gradle app")
        expect(app.output).to include("executing ./gradlew stage")
        expect(app.output).to include("BUILD SUCCESSFUL")
        expect(successful_body(app)).to include("Welcome to Grails")
      end
    end
  end
end
