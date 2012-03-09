require 'html5_validator'

describe Html5Validator::Crawler do
  let(:data) { File.open('spec/fixtures/scraper_html.html').read }
  let(:url) { 'http://damiannicholson.com' }

  describe :intialize do
    context "when passed invalid arguments or none" do
      it "should raise an ArgumentError exception if no arguments are passed" do
        lambda { described_class.new }.should raise_error ArgumentError
      end

      it "should raise an ArgumentError exception if an incorrect URL is passed" do
        lambda { described_class.new('boom.com') }.should raise_error ArgumentError
      end
    end

    context "when passed valid arguments" do
      subject do
        RestClient.stub(:get).and_return(data)
        described_class.new(url)
      end

      it "should be passed a url" do
        subject.url.should == url
      end

      it "should make a GET request to the root url and assign the response to data" do
        subject.data.should == data
      end
    end
  end

  describe :links do
    let(:data) { File.open('spec/fixtures/sageone_sitemap.html').read }
    let(:url) { 'http://sageone.com' }
    subject do
      RestClient.stub(:get).and_return(data)
      described_class.new(url)
    end

    it "should return an array" do
      subject.links.should be_an_instance_of Array
    end

    it "should not retrieve any external links" do
      subject.links.should_not include 'http://twitter.com/sageuk'
      subject.links.should_not include 'http://www.sage.com/'
    end

    it "should ensure that no links have any trailing slashes" do
      subject.links.select { |link| link[link.length - 1] == '/' }.should be_empty
    end

    it "should ensure no links are empty" do
      subject.links.select { |link| link.empty? }.should be_empty
    end

    it "should have 298 internal links" do
      subject.should have(298).links
    end

    it "should ensure each link is an absolute path and starts with http://sageone.com" do
      subject.links.reject { |link| link.start_with? url }.should be_empty
    end

  end

end
