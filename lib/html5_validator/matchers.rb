require 'html5_validator/validator'

# Assert that the response is valid HTML5
RSpec::Matchers.define :be_valid_html5 do
  validator = nil
  match do |body|
    validator = Html5Validator::Validator.new
    validator.validate_text(body)
    validator.valid?
  end
  failure_message do |actual|
    validator.inspect
  end
end
