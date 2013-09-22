require 'html5_validator/matchers'
require 'spec_helper'

describe Html5Validator::Validator do
  it "should be an instance of Html5Validator::Validator" do
    subject.should be_an_instance_of Html5Validator::Validator
  end

  describe "when using the custom matcher" do
    it "should not be valid html5 when supplied with invalid content" do
      @html = File.open('spec/fixtures/invalid_html.html').read
      @html.should_not be_valid_html5
    end

    it "should be valid html5 when supplied with valid content" do
      @html = File.open('spec/fixtures/valid_html.html').read
      @html.should be_valid_html5
    end
  end

  context "validating a uri" do
    describe "when supplied with an invalid url" do
      before do
        subject.validate_uri('http://google.co.uk')
      end

      it "should not be valid html5" do
        subject.valid?.should be_false
      end

      it "should return at least 1 error" do
        subject.should have_at_least(1).errors
      end
    end

    describe "when supplied with a valid url" do
      before do
        subject.validate_uri('http://damiannicholson.com')
      end

      it "should be valid html5" do
        subject.valid?.should be_true
      end

      it "should return zero errors" do
        subject.errors.should have(0).items
      end
    end
  end

  context "validating text" do
    describe "when supplied with invalid html" do
      before do
        @html = File.open('spec/fixtures/invalid_html.html').read
        subject.validate_text(@html)
      end

      it "should not be valid html5" do
         subject.valid?.should be_false
      end

      it "should return two errors" do
        subject.errors.should have(2).items
      end

      it "should include an error complaining about the lack of a closing section tag" do
        subject.inspect.should include('Unclosed element')
      end
    end

    describe "when supplied with valid html" do
      before do
        @html = File.open('spec/fixtures/valid_html.html').read
        subject.validate_text(@html)
      end

      it "should be valid html5" do
         subject.valid?.should be_true
      end

      it "should return no errors" do
        subject.errors.should have(0).items
      end
    end
  end
end
