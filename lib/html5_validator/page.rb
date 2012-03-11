require 'nokogiri'

module Html5Validator
  class Page

    # Public: Returns the String url of the Page
    attr_accessor :url

    # Public: Returns the HTML of the Page
    attr_accessor :body

    # Public: Create a new page
    #
    # url - The String url
    #
    # Examples
    #
    #   @page = new Html5Validator::Page.new('http://google.com')
    #
    # Returns a Page instance
    def initialize(url = nil)
      self.url = Html5Validator::Url.new(url)
      self.body = RestClient.get(self.url.full_path)
    end

    # Public: Retrieve all relative links within the page
    # and ensure they're not nil and unique
    #
    # Examples
    #
    #   @page.links
    #   # => [ '/foo-bar', '/hello-world' ]
    #
    # Returns an Array
    def links
      doc.xpath('//a[starts-with(@href, "/")]').map do |node|
        format_node_url(node)
      end.compact.uniq
    end

    def valid?
      validator.valid?
    end

    def errors
      validator.errors
    end

    private

    def validator
      @validator ||= Html5Validator.validate_text(body)
    end

    # Internal: Parses the HTML using Nokogiri
    #
    # Returns a Nokogiri object
    def doc
      @doc ||= Nokogiri::HTML(body)
    end

    # Internal: Ensures that a url doesn't have a trailing slash or is empty
    #
    # node - A Nokogiri node
    #
    # Returns a String url
    def format_node_url(node)
      absolute_url = [url.base_path, node.attributes['href'].to_s].join
      url = Html5Validator::Url.new(absolute_url)
      url.full_path
    end

  end
end
