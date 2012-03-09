require 'html5_validator'

describe Html5Validator::Sitemap do
  # let(:url) { 'http://sageone.com' }
  let(:url) { 'http://damiannicholson.com' }
  subject { described_class.new(url) }

  describe :intialize do
    it "should create a sitemap hash" do
      subject.sitemap.should be_an_instance_of Hash
    end

    it "should create the first item in the sitemap hash to have a key of the base_path" do
      subject.sitemap.keys.should include url
    end

    it "should create an instance of Html5Validator::Scraper for the base path in the sitemap" do
      subject.sitemap.values.first.should be_an_instance_of Html5Validator::Scraper
    end

    it "should populate the sitemap with all the internal links it can find on the passed in website" do
      puts '--------'
      puts subject.sitemap.keys
      subject.sitemap.keys.should have(29).items
      # subject.sitemap.keys.should have(1120).items
    end
  end

end
