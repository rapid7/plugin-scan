require_relative '../../lib/inspect_parameter_source'

describe InspectParameterSource do
  let(:source) { double }
  let(:headers) { Hash.new }
  subject { InspectParameterSource.new(source) }

  describe "#language" do
    before { source.stub_chain(:request, :headers).and_return(headers) }

    context "when language is set" do
      before { headers['HTTP_ACCEPT_LANGUAGE'] = 'en;en-us' }

      it "returns the set value" do
        expect(subject.language).to eq('en')
      end
    end

    context "when there is no language set" do
      it "return nil" do
        expect(subject.language).to be_nil
      end
    end
  end
end
