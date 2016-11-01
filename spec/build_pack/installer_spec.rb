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
      expect(described_class).to receive(:`).with(EXPECTED_DEB_COMMAND) {`#{STUBBED_DEB_COMMAND}`}

      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).to be
    end
  end

  context "when cache does not have client " do
    it "downloads and installs available client" do
      stub_request_to_debian_base_url(Helpers::RESPONSE_WITH_SUITABLE_CLIENTS)
      stub_request_for_expected_package

      BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).to be
    end

    it "it does not attempt to install when there are no available clients" do
      stub_request_to_debian_base_url(Helpers::RESPONSE_WITHOUT_SUITABLE_CLIENTS)

      expect{BuildPack::Installer.install(BUILD_DIR, CACHE_DIR)}.to raise_error(SystemExit)

      expect(File.exists?("#{MYSQL_INSTALLED_BINARY}")).not_to be
    end

  end
end
