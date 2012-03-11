require 'json'
require 'rest_client'

module Html5Validator
  class Validator

    BASE_URI = 'http://html5.validator.nu'
    HEADERS = { 'Content-Type' => 'text/html; charset=utf-8', 'Content-Encoding' => 'UTF-8' }

    def initialize(args)
      raise ArgumentError unless args[:method]

      @method = args[:method]
      @data = args[:data]
      @uri = args[:uri]
      @errors = []

      send("validate_#{@method}")
    end

    # def inspect
    #   @errors.map do |err|
    #     "- Error: #{err['message']}"
    #   end.join("\n")
    # end

    # Public: Determines whether the current resource is valid HTML
    #
    # Examples
    #
    #   @validator = Html5Validator.validate_uri('http://damiannicholson.com')
    #   @validator.valid?
    #   # => True
    #
    # Returns a Boolean
    def valid?
      errors.length.zero?
    end

    # Public: Retrieves the error messages from a JSON object
    #
    # Examples
    #
    #   @validator = Html5Validator.validate_uri('http://damiannicholson.com')
    #   @validator.errors
    #   # => [{'type','error','lastLine':9,'lastColumn':148}]
    #
    # Returns an Array of Hashes
    def errors
      @errors = response['messages'].select { |mssg| mssg['type'] == 'error' }
    end

    private

    # Internal: Validates a raw HTML String
    #
    # Returns JSON
    def validate_text
      raise ArgumentError unless @data
      @response = RestClient.post "#{BASE_URI}/?out=json", @data, HEADERS
    end


    # Internal: Validates markup of the passed in Url
    #
    # Returns JSON
    def validate_uri
      raise ArgumentError unless @uri
      @response = RestClient.get BASE_URI, :params => { :doc => @uri, :out => 'json' }
    end

    # Internal: Creates a JSON object from the response
    #
    # Returns a JSON object
    def response
      JSON.parse(@response.body)
    end

  end
end
