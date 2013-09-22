require 'json'
require 'rest_client'

module Html5Validator
  class Validator
    BASE_URI = 'http://validator.nu'
    HEADERS = { 'Content-Type' => 'text/html; charset=utf-8', 'Content-Encoding' => 'UTF-8' }
    attr_reader :errors

    def initialize(proxy = nil)
      RestClient.proxy = proxy unless proxy.nil?
    end

    # Validate the markup of a String
    def validate_text(text)
      response = RestClient.post "#{BASE_URI}/?out=json", text, HEADERS
      @json = JSON.parse(response.body)
      @errors = retrieve_errors
    end

    # Validate the markup of a URI
    def validate_uri(uri)
      response = RestClient.get BASE_URI, :params => { :doc => uri, :out => 'json' }
      @json = JSON.parse(response.body)
      @errors = retrieve_errors
    end

    # TODO - Flesh out the file upload method
    # Validate the markup of a file
    def validate_file(file)
    end

    def inspect
      @errors.map do |err|
        "- Error: #{err['message']}"
      end.join("\n")
    end

    def valid?
      @errors.length == 0
    end

    private

    def retrieve_errors
      @json['messages'].select { |mssg| mssg['type'] == 'error' }
    end
  end
end
