require 'html5_validator/matchers'

describe Html5Validator::Validator do
  let(:invalid_html) { File.open('spec/fixtures/invalid_html.html').read }
  let(:valid_html) { File.open('spec/fixtures/valid_html.html').read }

  describe "when using the custom matcher" do
    it "should not be valid html5 when supplied with invalid content" do
      expect(invalid_html).not_to be_valid_html5
    end

    it "should be valid html5 when supplied with valid content" do
      expect(valid_html).to be_valid_html5
    end
  end

  context "validating a uri" do
    describe "when supplied with an invalid url" do
      before do
        subject.validate_uri('http://google.co.uk')
      end

      it "should not be valid html5" do
        expect(subject.valid?).to be false
      end

      it "should return at least 1 error" do
        expect(subject).to have_at_least(1).errors
      end
    end

    describe "when supplied with a valid url" do
      before do
        subject.validate_uri('http://damiannicholson.com')
      end

      it "should be valid html5" do
        expect(subject.valid?).to be true
      end

      it "should return zero errors" do
        expect(subject).to have(0).errors
      end
    end
  end

  context "validating text" do
    describe "when supplied with invalid html" do
      before do
        subject.validate_text(invalid_html)
      end

      it "should not be valid html5" do
         expect(subject.valid?).to be false
      end

      it "should return two errors" do
        expect(subject).to have(2).errors
      end

      it "should include an error complaining about the lack of a closing section tag" do
        expect(subject.inspect).to include('Unclosed element')
      end
    end

    describe "when supplied with valid html" do
      before do
        subject.validate_text(valid_html)
      end

      it "should be valid html5" do
         expect(subject.valid?).to be true
      end

      it "should return no errors" do
        expect(subject).to have(0).errors
      end
    end
  end
end
