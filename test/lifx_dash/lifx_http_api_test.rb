require File.expand_path(File.dirname(__FILE__)+'/../test_helper')

class TestLifxHTTPApi <  MiniTest::Unit::TestCase

  def setup
    @logger     = MiniTest::Mock.new
    @api_client = LifxDash::LifxHTTPApi.new('my-token', @logger)
  end

  def test_toggles_lights_logging_successful
    selector = "d073d500ec8e"
    body = { results: [{ id: "d073d500ec8e", label: "Golden Boy", status: "ok" } ]}.to_json
    stub_request(:post, lifx_url(selector)).to_return(body: body, status: 207)

    @logger.expect(:info, nil, ["Toggling lights! (via #{LifxDash::LifxHTTPApi::BASE_URI})"])
    @logger.expect(:info, nil, ["Lights toggled successfully!"])
    @logger.expect(:info, nil, ["API reply (207): #{body}"])
    @api_client.toggle(selector)

    assert @logger.verify
  end

  def test_toggles_lights_logging_warnings
    selector = "all"
    http_responses = {
      401 => { error: "Invalid token" }, # invalid token in header
      500 => nil, # server issue
      207 => "{}" # server OK, but results not present
    }

    http_responses.each do |code, api_response_body|
      stub_request(:post, lifx_url(selector)).
        to_return(body: api_response_body.to_json, status: code)

      @logger.expect(:info, nil, ["Toggling lights! (via #{LifxDash::LifxHTTPApi::BASE_URI})"])
      @logger.expect(:warn, nil, ["Warning: Possible issue with LIFX lights or HTTP API response"])
      @logger.expect(:warn, nil, ["API reply (#{code}): #{api_response_body.to_json}"])
      @api_client.toggle(selector)

      assert @logger.verify
    end
  end

  def test_raises_error_on_toggle_when_http_errors
    assert_raises(Errno::ECONNRESET) do
      @logger.expect(:info, nil, ["Toggling lights! (via #{LifxDash::LifxHTTPApi::BASE_URI})"])
      @logger.expect(:error, nil, ["Error: POST request to #{LifxDash::LifxHTTPApi::BASE_URI} failed: Connection reset by peer"])

      net_error = -> (uri) { raise Errno::ECONNRESET.new }
      Net::HTTP::Post.stub :new, net_error do
        @api_client.toggle('all')
      end

      assert @logger.verify
    end
  end

  def test_raises_error_on_toggle_with_bad_selector
    assert_raises(URI::InvalidURIError) do
      bad_selector = "im a bad bulb selector"
      @logger.expect(:error, nil, ["Error: POST request to #{LifxDash::LifxHTTPApi::BASE_URI} failed: bad URI(is not URI?): #{lifx_url(bad_selector)}"])
      @api_client.toggle(bad_selector)

      assert @logger.verify
    end
  end

  private

  def lifx_url(selector)
    "https://#{LifxDash::LifxHTTPApi::BASE_URI}/lights/#{selector}/toggle"
  end
end
