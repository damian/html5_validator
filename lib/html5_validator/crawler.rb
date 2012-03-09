require 'rest_client'

module Html5Validator
  class Crawler

    # Public : Returns a Hash of Pages
    attr_accessor :pages

    def initialize(url = nil)
      raise ArgumentError if url.nil?

      uri = URI(url)
      @base_path = [ uri.scheme, '://', uri.host ].join
      @full_path = [ @base_path, uri.path ].join

      self.pages = {}

      crawl_page(@full_path)
    end

    private

    def crawl_page(url)
      # Ensure we haven't crawled this page before
      return unless valid? url

      body = nil
      begin
        body = RestClient.get(url)
      rescue Exception => e
      else
        # Ensure the body isn't empty
        return if body.nil?

        page = Page.new(url)
        page.body = body
        self.pages[page.url] = page
        puts page.url

        page.links.each do |link|
          crawl_page(link)
        end
      end
      pages
    end

    # Private: Determines whether we've visited this page before
    #
    # Returns a Boolean
    def visited?(url)
      pages.include? url
    end

    # Private: Determines whether the page
    #
    # Returns a Boolean
    def same_domain?(url)
      url.start_with? @base_path
    end


    # Private: Determines if a url is valid
    #
    # Returns a Boolean
    def valid?(url)
      same_domain?(url) && !visited?(url)
    end

  end
end
