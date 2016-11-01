require 'spec_helper'

describe BuildPack::Downloader do
  context "when there are several packages available" do
    it "picks the most recent amd64 package" do
      stub_request_to_debian_base_url(Helpers::RESPONSE_WITH_SUITABLE_CLIENTS)

      expect(BuildPack::Downloader.most_recent_client).to eql("#{Helpers::EXPECTED_PACKAGED}")
    end
  end
end
