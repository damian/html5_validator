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
      raise ArgumentError if url.nil?

      uri = URI(url)
      @base_path = [ uri.scheme, '://', uri.host ].join
      @full_path = [ @base_path, uri.path ].join

      self.url = @full_path
    end

    # Public: Retrieve all the internal links within the page
    # and ensure they're not nil and unique
    #
    # Examples
    #   @page.links
    #   # => [ 'http://google.com', 'http://google.com/calendar' ]
    #
    # Returns an Array
    def links
      doc.xpath('//a[starts-with(@href, "/")]').map do |node|
        format_node_url(node)
      end.compact.uniq
    end


    private

    def doc
      @doc ||= Nokogiri::HTML(body)
    end

    # Internal: Ensures that a url doesn't have a trailing slash or is empty
    #
    # Returns a String url
    def format_node_url(node)
      local_url = @base_path + remove_anchor(node.attributes['href'].to_s)
      uri = URI(local_url)
      @base_path + uri.path
    end

    def remove_anchor(path)
      path.split('#')[0]
    end


  end
end
