module Html5Validator
  class Url

    # Public: Create a new Url
    #
    # url - The String url
    #
    # Examples
    #
    #   @url = new Html5Validator::Url.new('http://google.com')
    #
    # Returns a Url instance
    def initialize(url = nil)
      raise ArgumentError unless valid?(url)
      @uri = URI(url.split('?')[0])
    end

    # Public: Returns the base path including the protocol for the
    # passed in url
    #
    # Examples
    #
    #   @url = Html5Validator::Url.new('http://damiannicholson.com/blog?hello-world
    #   @url.base_path
    #   # => 'http://damiannichlson.com'
    #
    # Returns a String
    def base_path
      [ @uri.scheme, '://', @uri.host ].join
    end

    # Public: Returns the full path for the passed in url. Ensures
    # that it contains no querystring or hash data
    #
    # Examples
    #
    #   @url = Html5Validator::Url.new('http://damiannicholson.com/blog?hello-world
    #   @url.base_path
    #   # => 'http://damiannichlson.com/blog'
    #
    #   @url = Html5Validator::Url.new('http://damiannicholson.com/blog?hello-world#foo
    #   @url.base_path
    #   # => 'http://damiannichlson.com/blog'
    #
    # Returns a String
    def full_path
      path = @uri.path.split('#')[0]
      if /^(.*)\/$/.match(path)
        path = $1
      end
      [ base_path, path ].join
    end

    private

    # Internal: Determines if the url is formatted correctly. Forces
    # the match in to a Boolean using the double bang
    #
    # url - A String url e.g. 'http://google.com'
    #
    # Returns a Boolean
    def valid?(url)
      !!(url =~ URI::regexp)
    end

  end
end
