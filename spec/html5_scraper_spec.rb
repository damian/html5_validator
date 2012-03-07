require 'html5_validator'

describe Html5Validator::Scraper do
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
    subject do
      RestClient.stub(:get).and_return(data)
      described_class.new('http://localhost')
    end

    it "should return an array" do
      subject.links.should be_an_instance_of Array
    end

    it "should not retrieve any external links" do
      subject.links.should_not include 'http://google.com'
    end

    it "should remove any non nil elements from links" do
      subject.links.should_not include nil
    end

  end

end
