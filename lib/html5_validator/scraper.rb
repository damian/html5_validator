require 'nokogiri'

module Html5Validator
  class Scraper

    # Public: Returns the String url of the webpage to be scraped
    attr_accessor :url

    # Public: Returns a the HTML of the webpage to be scraped
    attr_accessor :data

    # Public: Returns the Nokogiri object of the HTML tree
    attr_accessor :nokogiri_data

    # Public: Initialize a new Scraper.
    #
    # url - The String url
    #
    # Examples
    #
    #   @scraper = new Html5Validator::Scraper.new('http://google.com')
    #
    # Returns a Scraper instance
    def initialize(url = nil)
      raise ArgumentError unless url_valid?(url)

      self.url = url
      self.data = RestClient.get(url)
      self.nokogiri_data = Nokogiri::HTML(data)
    end

    def base_url
      uri = URI(self.url)
      [uri.scheme, '://', uri.host].join.strip
    end

    # Public: Retrieve all the unique anchors within the page that
    # contain an href attribute
    #
    # Examples
    #   @scraper.links
    #   # => [ 'http://google.com', 'http://damiannicholson.com' ]
    #
    # Returns an Array
    def links
      nokogiri_data.xpath('//a[starts-with(@href, "/")]').map do |node|
        format_node_url(node)
      end.uniq
    end

    private

    # Internal: Ensures that a url doesn't have a trailing slash
    #
    # Returns a String url
    def format_node_url(node)
      url = base_url + node.attributes['href'].to_s
      /^(.*)\/$/.match(url) ? $1 : url
    end

    # Internal: Determines if the url passed in is formatted correctly
    #
    # Returns a Boolean
    def url_valid?(link)
      link =~ URI::regexp
    end

  end
end
