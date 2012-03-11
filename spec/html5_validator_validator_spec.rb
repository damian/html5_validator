require 'html5_validator'

describe Html5Validator::Validator do

  describe :validate_uri do
    context "when supplied with a url that contains invalid markup" do
      class TestInvalidResponse
        def body
          File.read('spec/fixtures/response.json')
        end
      end

      subject do
        RestClient.stub(:get).and_return(TestInvalidResponse.new)
        described_class.new(:method => :uri, :uri => 'http://google.com')
      end

      it "should have an array of errors" do
        subject.errors.should be_an_instance_of Array
      end

      it "should not be valid html5" do
        subject.valid?.should be_false
      end

      it "should have more than 1 error" do
        subject.should have_at_least(1).errors
      end
    end

    context "when supplied with a url that contains valid markup" do
      class TestValidResponse
        def body
          '{"messages":[]}'
        end
      end

      subject do
        RestClient.stub(:get).and_return(TestValidResponse.new)
        described_class.new(:method => :uri, :uri => 'http://google.com')
      end

      it "should be valid html5" do
        subject.valid?.should be_true
      end

      it "should have no errors" do
        subject.should have(0).errors
      end
    end
  end

end
