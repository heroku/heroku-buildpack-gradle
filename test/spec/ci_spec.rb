require_relative "spec_helper"

describe "heroku-buildpack-gradle" do
  context "on Heroku CI" do
    it "should not compile twice, leveraging Gradle's build cache" do
      new_default_hatchet_runner("test/spec/fixtures/ci-test-app").tap do |app|
        app.run_ci do |test_run|
          expect(test_run.output).to match(%r{> Task :compileJava$})
          expect(test_run.output).to match(%r{> Task :compileJava UP-TO-DATE$})
        end
      end
    end
  end
end
