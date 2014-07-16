require File.expand_path(File.dirname(__FILE__) + "/../../../lib/use_cases/creates_hits")

module UseCases
  describe CreatesHits do
    before { stub_const('Hit', Class.new) }

    describe ".create" do
      let(:data) { double }
      let(:hit)  { double.as_null_object }
      let(:id)   { 'the-id' }
      let(:hash) { double }

      before do
        data.stub(:to_hash => hash)
        Hit.stub(:new => hit) 
      end

      it "instantiates a new hit" do
        Hit.should_receive(:new).with(hash) { hit }
        CreatesHits.create(id, data)
      end

      it "assigns the id" do
        hit.should_receive(:_id=).with(id)
        CreatesHits.create(id, data)
      end

      it "saves the hit" do
        hit.should_receive(:save!)
        CreatesHits.create(id, data)
      end
    end
  end
end
