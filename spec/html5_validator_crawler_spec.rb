require 'html5_validator'

describe Html5Validator::Crawler do
  let(:url) { 'http://damiannicholson.com' }
  let(:data) { File.read('spec/fixtures/damiannicholson.html') }

  subject do
    RestClient.stub(:get).and_return(data)
    described_class.new(url)
  end

  describe :initialize do
    it "should create a pages hash" do
      subject.sitemap.should be_an_instance_of Hash
    end

    it "should create an instance of Html5Validator::Url" do
      subject.url.should be_an_instance_of Html5Validator::Url
    end
  end

  describe :urls do
    it "should create the first item in the sitemap hash to have a key of the base_path" do
      subject.urls.first.should == url
    end

    it "should list jquery inconsistencies as the last url" do
      subject.urls.last.should == "#{url}/2011/12/05/jquery-inconsistencies.html"
    end

    it "should ensure that all urls begin with http://damiannicholson.com" do
      subject.urls.reject { |link| link.start_with? url }.should be_empty
    end
  end

  describe :pages do
    it "should create an instance of Html5Validator::Page for the base path in the sitemap" do
      subject.pages.first.should be_an_instance_of Html5Validator::Page
    end
  end
end
