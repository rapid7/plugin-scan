require 'spec_helper'

RSpec::Matchers.define :includes_instance_of do |klass|
  match do |objects|
    includes_instance = false
    objects.each do |object|
      if object.instance_of?(klass)  
        includes_instance = true
        break
      end
    end
    includes_instance
  end

  failure_message_for_should do |actual|
    "expected array to include an instance of #{klass}"
  end
end

module Stats
  describe WriterFactory do
    describe "#all_writers" do
      it "includes BrowserWriter" do
        expect(subject.all_writers).to includes_instance_of(Writers::BrowserWriter)
      end

      it "includes OperatingSystemWriter" do
        expect(subject.all_writers).to includes_instance_of(Writers::OperatingSystemWriter)
      end

      it "includes TrafficWriter" do
        expect(subject.all_writers).to includes_instance_of(Writers::TrafficWriter)
      end

      it "includes AddonWriter" do
        expect(subject.all_writers).to includes_instance_of(Writers::AddonWriter)
      end

      it "includes IpAddressWriter" do
        expect(subject.all_writers).to includes_instance_of(Writers::IpAddressWriter)
      end

      it "includes ReferrerWriter" do
        expect(subject.all_writers).to includes_instance_of(Writers::ReferrerWriter)
      end

      it "includes CountryWriter" do
        expect(subject.all_writers).to includes_instance_of(Writers::CountryWriter)
      end
    end
  end
end
