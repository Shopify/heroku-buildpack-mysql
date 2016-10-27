require 'spec_helper'

TMP_DIR = "tmp"
CACHE_DIR = "#{TMP_DIR}/cache_dir"
BUILD_DIR = "#{TMP_DIR}/build_dir"
DPKG_BIN_DIR = "#{BUILD_DIR}/tmp/mysql/usr/bin"
DPKG_BIN_OUTPUT = "#{DPKG_BIN_DIR}/fake_binary"
MYSQL_INSTALLED_BINARY = "#{BUILD_DIR}/bin/fake_binary"

EXPECTED_DEB_COMMAND = "dpkg -x #{CACHE_DIR}/mysql.deb #{BUILD_DIR}/tmp/mysql"
STUBBED_DEB_COMMAND = "mkdir -p #{DPKG_BIN_DIR}; touch #{DPKG_BIN_OUTPUT}"

describe BuildPack::Installer do
  before{`mkdir #{TMP_DIR}`}
  before{`mkdir #{CACHE_DIR}`}
  before{`mkdir #{BUILD_DIR}`}
  after{`rm -r #{TMP_DIR}`}

  context "when cache already has client" do
    before{`touch #{CACHE_DIR}/mysql.deb`}

    it "installs cached client" do
      expect(described_class).to receive(:`).with(EXPECTED_DEB_COMMAND) { `#{STUBBED_DEB_COMMAND}` }

      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).to be
    end
  end

  context "when cache does not have client " do
    it "downloads and installs client" do
      stub_request(:get, "http://security.debian.org/pool/updates/main/m/mysql-5.5").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'security.debian.org', 'User-Agent'=>'Ruby'}).
        to_return(
          :status => 200,
          :body => SAMPLE_DEBIAN_RESPONSE,
          :headers => {})

      stub_request(:get, "http://security.debian.org/pool/updates/main/m/mysql-5.5/mysql-client-5.5_5.5.62-0+deb7u1_amd64.deb").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'security.debian.org', 'User-Agent'=>'Ruby'}).
        to_return(
          :status => 200,
          :body => "fake binary data",
          :headers => {})
      expect(described_class).to receive(:`).with(EXPECTED_DEB_COMMAND) { `#{STUBBED_DEB_COMMAND}` }


      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).to be
    end
  end
end
