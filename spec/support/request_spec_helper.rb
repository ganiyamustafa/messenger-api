require 'json-schema'

module RequestSpecHelper
  # Parse JSON response to ruby hash
  def response_body
    JSON.parse(response.body, symbolize_names: true).with_indifferent_access
  end

  def response_data
    response_body[:data]
  end

  def expect_response(status, json = nil)
    begin
      expect(response).to have_http_status(status)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      e.message << "\n#{JSON.pretty_generate(response_body)}"
      raise e
    end
    expect(JSON::Validator.validate!(json, response_body)).to be true if json
  end
end
