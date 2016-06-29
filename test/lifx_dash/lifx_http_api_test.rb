require File.expand_path(File.dirname(__FILE__)+'/../test_helper')

describe LifxDash::LifxHTTPApi do

  it "should have a token" do
    api_client = LifxDash::LifxHTTPApi.new('my-token')
    api_client.token.must_equal 'my-token'
  end

  it "should have a base uri" do
    LifxDash::LifxHTTPApi::BASE_URI.must_equal "api.lifx.com/v1"
  end
end
