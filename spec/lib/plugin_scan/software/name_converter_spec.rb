require 'spec_helper'

module PluginScan
  module Software
    describe NameConverter do
      describe "#as_symbol" do
        it "converts Adobe Reader to a symbol" do
          expect(subject.as_symbol('Adobe Reader')).to eq(:ao_reader)
        end

        it "converts Phoscode DevalVR to a symbol" do
          expect(subject.as_symbol('Phoscode DevalVR')).to eq(:ao_dvr)
        end 

        it "converts Adobe Flash to a symbol" do
          expect(subject.as_symbol('Adobe Flash')).to eq(:ao_flash)
        end 

        it "converts Oracle Java to a symbol" do
          expect(subject.as_symbol('Oracle Java')).to eq(:ao_java)
        end 

        it "converts Apple Quicktime to a symbol" do
          expect(subject.as_symbol('Apple Quicktime')).to eq(:ao_qt)
        end 

        it "converts RealPlayer to a symbol" do
          expect(subject.as_symbol('RealPlayer')).to eq(:ao_rp)
        end 

        it "converts Adobe Shockwave to a symbol" do
          expect(subject.as_symbol('Adobe Shockwave')).to eq(:ao_shock)
        end

        it "converts Microsoft Silverlight to a symbol" do
          expect(subject.as_symbol('Microsoft Silverlight')).to eq(:ao_silver)
        end

        it "converts Windows Media Player to a symbol" do
          expect(subject.as_symbol('Windows Media Player')).to eq(:ao_wmp)
        end

        it "converts VLC Media Player" do
          expect(subject.as_symbol('VLC Media Player')).to eq(:ao_vlc)
        end
      end
    end
  end
end
