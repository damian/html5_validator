require 'html5_validator'

describe Html5Validator::Url do
  let(:url) { 'http://damiannicholson.com/blog/' }

  describe :initialize do
    it "should raise an ArgumentError exception if no arguments are passed" do
      lambda { described_class.new }.should raise_error ArgumentError
    end

    it "should raise an ArgumentError exception if an incorrect URL is passed" do
      lambda { described_class.new('boom.com') }.should raise_error ArgumentError
    end
  end

  describe :base_path do
    subject { described_class.new(url) }

    it "should return a String" do
      subject.base_path.should be_an_instance_of String
    end

    it "should return the root url e.g. http://damiannicholson.com" do
      subject.base_path.should == 'http://damiannicholson.com'
    end

    it "should not contain the path e.g. /blog/" do
      subject.base_path.should_not include '/blog/'
    end
  end

  describe :full_path do
    subject { described_class.new(url) }

    it "should return a String" do
      subject.full_path.should be_an_instance_of String
    end

    it "should return a url without a trailing slash" do
      subject.full_path[-1].should_not == '/'
    end

    it "should return the full path e.g. http://damiannicholson.com/blog" do
      subject.full_path.should == 'http://damiannicholson.com/blog'
    end
  end
end
