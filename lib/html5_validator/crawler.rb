require 'rest_client'

module Html5Validator
  class Crawler

    # Public: Returns a Hash of Page objects
    attr_accessor :sitemap

    # Public: Returns a Html5Validator::Url object
    attr_accessor :url

    # Public: Create a new Crawler object
    #
    # url - The String url
    #
    # Example
    #
    #   @crawler = Html5Validator::Crawler.new('http://google.com')
    #
    # Returns a Crawler instance
    def initialize(url = nil)
      self.url = Html5Validator::Url.new(url)
      self.sitemap = {}

      crawl_page(self.url.full_path)
    end

    # Public: Retrieve a list of urls
    #
    # Example
    #
    #   @crawler.urls
    #     => [ 'http://google.com', 'http://google.com/ig' ]
    #
    # Returns an Array of String urls
    def urls
      sitemap.keys
    end

    # Public: Retrieve a list of Page objects
    #
    # Returns an Array of Page objects
    def pages
      sitemap.values
    end

    private

    # Internal: Recursive function to retrieve the contents of a webpage
    #
    # url - A String url e.g. 'http://google.com'
    #
    # Returns the pages Hash
    def crawl_page(url)
      # Ensure we haven't crawled this page before
      return unless valid? url

      body = nil
      begin
        body = RestClient.get url
      rescue Exception => e
      else
        return if body.nil?

        # Create a new page instance and assign the response to its body
        page = Page.new(url)
        page.body = body

        # Add the Page instance to our pages Hash
        self.sitemap[page.url.full_path] = page

        # Crawl any links found
        page.links.each do |link|
          crawl_page(link)
        end
      end

      sitemap
    end

    # Internal: Determines whether we've visited this page before
    #
    # url - A String url e.g. 'http://google.com'
    #
    # Returns a Boolean
    def visited?(url)
      sitemap.include? url
    end

    # Internal: Determines whether the page is within the current domain
    #
    # url - A String url e.g. 'http://google.com'
    #
    # Returns a Boolean
    def same_domain?(url)
      url.start_with? self.url.base_path
    end

    # Internal: Proxy function to ensure the page is within the current domain
    # and hasn't already been visited by our crawler
    #
    # url - A String url
    #
    # Returns a Boolean
    def valid?(url)
      same_domain?(url) && !visited?(url)
    end

  end
end
