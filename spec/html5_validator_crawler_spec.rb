require 'html5_validator'

describe Html5Validator::Crawler do
  let(:url) { 'http://damiannicholson.com' }
  subject { described_class.new(url) }

  describe :initialize do
    it "should create a pages hash" do
      subject.sitemap.should be_an_instance_of Hash
    end

    it "should create an instance of Html5Validator::Url" do
      subject.url.should be_an_instance_of Html5Validator::Url
    end

    it "should create the first item in the sitemap hash to have a key of the base_path" do
      subject.urls.first.should == url
    end

    it "should create an instance of Html5Validator::Page for the base path in the sitemap" do
      subject.pages.first.should be_an_instance_of Html5Validator::Page
    end
  end
end
