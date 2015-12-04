describe Fastlane do
  describe Fastlane::FastFile do
    describe "Hockey Integration" do
      it "raises an error if no ipa file was given" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            hockey({
              api_token: 'xxx'
            })
          end").runner.execute(:test)
        end.to raise_error("Couldn't find ipa file at path ''".red)
      end

      it "raises an error if given ipa file was not found" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            hockey({
              api_token: 'xxx',
              ipa: './notHere.ipa'
            })
          end").runner.execute(:test)
        end.to raise_error("Couldn't find ipa file at path './notHere.ipa'".red)
      end

      it "raises an error if supplied dsym file was not found" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            hockey({
              api_token: 'xxx',
              ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
              dsym: './notHere.dSYM.zip'
            })
          end").runner.execute(:test)
        end.to raise_error("Symbols on path '#{File.expand_path('../notHere.dSYM.zip')}' not found".red)
      end

      it "works with valid parameters" do
        Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1'
          })
        end").runner.execute(:test)
      end

      it "has the correct default values" do
        values = Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1'
          })
        end").runner.execute(:test)

        expect(values[:notify]).to eq(1.to_s)
        expect(values[:status]).to eq(2.to_s)
        expect(values[:notes]).to eq("No changelog given")
        expect(values[:release_type]).to eq(0.to_s)
        expect(values[:tags]).to eq(nil)
        expect(values[:teams]).to eq(nil)
        expect(values[:mandatory]).to eq(0.to_s)
        expect(values[:notes_type]).to eq(1.to_s)
        expect(values[:upload_dsym_only]).to eq(false)
      end

      it "can use a   generated changelog as release notes" do
        values = Fastlane::FastFile.new.parse("lane :test do
          # changelog_from_git_commits sets this lane context variable
          Actions.lane_context[SharedValues::FL_CHANGELOG] = 'autogenerated changelog'
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
          })
        end").runner.execute(:test)

        expect(values[:notes]).to eq('autogenerated changelog')
      end

      it "has the correct default notes_type value" do
        values = Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
          })
        end").runner.execute(:test)

        expect(values[:notes_type]).to eq("1")
      end

      it "can change the notes_type" do
        values = Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
            notes_type: '0'
          })
        end").runner.execute(:test)

        expect(values[:notes_type]).to eq("0")
      end

      it "can change the release_type" do
        values = Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
            release_type: '1'
          })
        end").runner.execute(:test)

        expect(values[:release_type]).to eq(1.to_s)
      end

      it "can change teams" do
        values = Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
            teams: '123,123'
          })
        end").runner.execute(:test)

        expect(values[:teams]).to eq('123,123')
      end

      it "can change mandatory" do
        values = Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
            mandatory: '1'
          })
        end").runner.execute(:test)

        expect(values[:mandatory]).to eq(1.to_s)
      end

      it "can change tags" do
        values = Fastlane::FastFile.new.parse("lane :test do
          hockey({
            api_token: 'xxx',
            ipa: './fastlane/spec/fixtures/fastfiles/Fastfile1',
            tags: '123,123'
          })
        end").runner.execute(:test)

        expect(values[:tags]).to eq('123,123')
      end
    end
  end
end
