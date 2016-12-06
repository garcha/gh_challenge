require_relative 'gh_challenge_v2'

describe GithubChallenge do

  it "handles empty parameter" do
    gh = GithubChallenge.new(["--before", "2016-11-02T03:12:14-03:00", "--event", "PushEvent", "--count", "42"])
    expect(gh.validate_date).to include("Missing after value, please use the following format")
  end

  it "handles empty parameter" do
    gh = GithubChallenge.new(["--after", "2016-11-01T13:00:00Z", "--event", "PushEvent", "--count", "42"])
    expect(gh.validate_date).to include("Missing before value, please use the following format")
  end

  it "handles empty parameter" do
    gh = GithubChallenge.new(["--before", "2016-11-02T03:12:14-03:00", "--after", "2016-11-01T13:00:00Z", "--count", "42"])
    expect(gh.validate_date).to include("Missing event value, please use the following format")
  end

  it "handles empty parameter" do
    gh = GithubChallenge.new(["--before", "2016-11-02T03:12:14-03:00", "--after", "2016-11-01T13:00:00Z", "--event", "PushEvent"])
    expect(gh.validate_date).to include("Missing count value, please use the following format")
  end

  it "returns expected number of records" do
    gh = GithubArchiver.new(["--after", "2016-11-01T13:00:00Z", "--before", "2016-11-02T03:12:14-03:00", "--event", "PushEvent", "--count", "42"])
    results = gh.execute
    expect(results.length).to eq(42)
    puts results
  end

end
