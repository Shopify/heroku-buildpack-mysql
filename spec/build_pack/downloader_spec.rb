require 'spec_helper'

describe BuildPack::Downloader do
  context "when there are several packages available" do
    it "picks the most recent amd64 package" do
      stub_request(:get, "http://security.debian.org/pool/updates/main/m/mysql-5.5").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'security.debian.org', 'User-Agent'=>'Ruby'}).
        to_return(
          :status => 200,
          :body => SAMPLE_DEBIAN_RESPONSE,
          :headers => {})

      expect(BuildPack::Downloader.most_recent_client).to eql("mysql-client-5.5_5.5.62-0+deb7u1_amd64.deb")
    end
  end
end
