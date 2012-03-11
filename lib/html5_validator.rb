require File.dirname(__FILE__) + '/html5_validator/matcher'
require File.dirname(__FILE__) + '/html5_validator/validator'
require File.dirname(__FILE__) + '/html5_validator/url'
require File.dirname(__FILE__) + '/html5_validator/page'
require File.dirname(__FILE__) + '/html5_validator/crawler'

module Html5Validator

  def self.proxy(proxy)
    RestClient.proxy = proxy
  end

  def self.validate_text(text)
    Validator.new(:method => :text, :data => text)
  end

  def self.validate_uri(uri)
    Validator.new(:method => :uri, :uri => uri)
  end

  def self.validate_website(uri)
    Crawler.new(uri)
  end

end
