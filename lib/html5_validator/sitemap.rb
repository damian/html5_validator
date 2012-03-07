module Html5Validator
  class Sitemap

    # Public: Returns a Hash of the Sitemap
    attr_accessor :sitemap

    # Public: Initialize a new Sitemap.
    #
    # url - The String url
    #
    # Examples
    #
    #   @scraper = new Html5Validator::Sitemap.new('http://google.com')
    #
    # Returns a Sitemap instance
    def initialize(url = nil)
      raise ArgumentError if url.nil?

      self.sitemap = {}
      scraper = Html5Validator::Scraper.new(url)
      sitemap[url] = scraper
      parse_webpage(scraper.links)
    end

    private

    # Internal: Recursive function to loop through an array of urls
    # and determine if they're already present in the sitemap. If not
    # then those are crawled using our Scraper class.
    #
    # Returns nothing
    def parse_webpage(links)
      links.each do |link|
        next if sitemap.include? link

        begin
          scraper = Html5Validator::Scraper.new(link)
        rescue Exception => e
          puts '---------'
          puts 'Exception = ' + link
          puts '---------'
          next
        else
          sitemap[scraper.url] = scraper
          parse_webpage(scraper.links)
        end
      end
    end

  end
end
