require 'spec_helper'

describe VersionFinder do
  describe "#current" do
    subject { VersionFinder.new('linux', 'chrome') }

    it "returns current plugin versions" do
      expect(subject.current(:br)).to eq('23,0,1271,95')
      expect(subject.current(:reader)).to eq('9,5,5')
      expect(subject.current(:dvr)).to eq('0,9,0,2')
      expect(subject.current(:flash)).to eq('11,8,800,115')
      expect(subject.current(:java)).to eq('1,7,0,25')
      expect(subject.current(:qt)).to eq('')
      expect(subject.current(:rp)).to eq('16,0,0,282')
      expect(subject.current(:shock)).to eq('')
      expect(subject.current(:silver)).to eq('')
      expect(subject.current(:wmp)).to eq('')
      expect(subject.current(:vlc)).to eq('2,0,8')
    end
  end

  describe "#security" do
    subject { VersionFinder.new('windows', 'ie') }

    it "returns security plugin versions" do
      expect(subject.security(:br)).to eq('6')
      expect(subject.security(:reader)).to eq('11,0,0')
      expect(subject.security(:dvr)).to eq('0,9,0,2')
      expect(subject.security(:flash)).to eq('11,8,800,94')
      expect(subject.security(:java)).to eq('1,7,0,25')
      expect(subject.security(:qt)).to eq('7,7,4')
      expect(subject.security(:rp)).to eq('16,0,0,282')
      expect(subject.security(:shock)).to eq('12,0,3,133')
      expect(subject.security(:silver)).to eq('5,1,20513,0')
      expect(subject.security(:wmp)).to eq('')
      expect(subject.security(:vlc)).to eq('2,0,8')
    end
  end
end
