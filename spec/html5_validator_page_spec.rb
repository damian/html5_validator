require 'html5_validator'

describe Html5Validator::Page do
  let(:url) { 'http://damiannicholson.com' }
  subject { described_class.new(url) }

  describe :initialize do

    it "should have a String url" do
      subject.url.should be_an_instance_of Html5Validator::Url
    end

    it "should throw an error when passed an invalid url" do
      lambda { described_class.new }.should raise_error ArgumentError
    end
  end

  describe :links do
    let(:data) { File.open('spec/fixtures/scraper_html.html').read }
    subject { described_class.new(url) }

    before do
      subject.body = data
    end

    it "should return an array" do
      subject.links.should be_an_instance_of Array
    end

    it "should not retrieve any external links" do
      subject.links.should_not include 'http://google.com'
      subject.links.should_not include 'http://damiannicholson.com'
    end

    it "should ensure each link is an absolute path and starts with http://damiannicholson.com" do
      subject.links.reject { |link| link.start_with? url }.should be_empty
    end

    it "should ensure no links are empty or nil" do
      subject.links.select { |link| link.empty? || link.nil? }.should be_empty
    end

    it "should have 2 internal links" do
      subject.should have(2).links
    end
  end
end
