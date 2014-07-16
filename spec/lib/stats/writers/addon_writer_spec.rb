require 'spec_helper'

module Stats::Writers
  describe AddonWriter do
    describe "#write" do
      let(:document) { DailyStats.create }
      
      it "implements the write interface" do
        expect(subject.respond_to?(:write)).to be_true
      end

      context "with a new addon visit" do
        let(:new_visit) do
          double('safari', 
                 hit: {
                   :br       => 'safari',
                   :os       => 'macintosh',
                   :ao_flash => '5,4,3,2'
                 }
          ).as_null_object 
        end

        before { subject.write(document, new_visit) }

        it "adds a new entry" do
          name = DailyStats.first.addons.first['name']
          expect(name).to eq('flash')
        end

        it "sets the intial count as 1" do
          count = DailyStats.first.addons.first['count']
          expect(count).to eq(1)
        end

        it "stores the visit details" do
          details = DailyStats.first.flash.first
          expect(details).to eq({
            'os'       => 'macintosh',
            'browser'  => 'safari',
            'version'  => '5.4.3.2',
            'count'    => 1,
            'outdated' => false
          })
        end
      end

      context "with an existing addon visit" do
        let(:existing_visit) do
          double('chrome', 
                 hit: {
                    :br       => 'chrome',
                    :os       => 'macintosh',
                    :ao_java  => '1,2,3,4',
                 }
          ).as_null_object 
        end

        before do
          document.add_to_set(:addons, {
            'name'    => 'java', 
            'count'   => 1
          })

          document.add_to_set(:java, {
            'os'       => 'macintosh',
            'browser'  => 'chrome',
            'version'  => '1.2.3.4',
            'count'    => 1,
            'outdated' => false
          })
          subject.write(document, existing_visit)
        end

        it "does not add an additional entry" do
          expect(DailyStats.first.addons.size).to eq(1)
        end

        it "increments the total addon count" do
          count = DailyStats.first.addons.first['count']
          expect(count).to eq(2)
        end

        it "increments the count in the addon details" do
          details = DailyStats.first.java.first
          expect(details['count']).to eq(2)
        end

        context "with failures" do
          let(:visit_with_failures) do
            double('failures',
                   failures: { 
                     :br       => 'chrome',
                     :os       => 'macintosh',
                     :ao_java  => '1,2,3,4'
                   },
                   has_failures?: true
            ).as_null_object
          end

          it "changes outdated to true" do
            subject.write(document, visit_with_failures)
            details = DailyStats.first.java.first
            expect(details['outdated']).to eq(true)
          end
        end

        context "with a different browser" do
          let(:another_browser_visit) do
            double('chrome', 
                   hit: {
                     :br       => 'firefox',
                     :os       => 'macintosh',
                     :ao_java  => '1,2,3,4',
                   },
                   has_failures?: false
            ).as_null_object 
          end

          before { subject.write(document, another_browser_visit) }

          it "increases the total count" do
            count = DailyStats.first.addons.first['count']
            expect(count).to eq(3)
          end

          it "adds new details for java" do
            details = DailyStats.first.java[1]
            expect(details).to eq({
              'os'       => 'macintosh',
              'browser'  => 'firefox',
              'version'  => '1.2.3.4',
              'count'    => 1,
              'outdated' => false
            })
          end
        end
      end
    end
  end
end
