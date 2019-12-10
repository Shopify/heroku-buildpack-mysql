require 'net/http'

module BuildPack
  class Downloader
    MYSQL_BASE_URL = "http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/"

    # example client: "mysql-client-5.5_5.5.52-0+deb8u1_amd64.deb"
    REGEX = /.*(mysql-client-8\.0_8\.0\.18\d\d-0\+ubuntu2_amd64.deb).*/

    class << self
      def download_latest_client_to(path)
        Logger.log_header("Downloading MySQL Client package")

        client = most_recent_client

        if client.empty?
          Logger.log("No suitable clients available")
          return
        end

        Logger.log("Selecting: #{client}")

        File.open(path, 'w+').write(Net::HTTP.get(URI.parse("#{MYSQL_BASE_URL}#{client}")))
      end

      def most_recent_client
        Logger.log("Looking for clients at: #{MYSQL_BASE_URL}")

        response = Net::HTTP.get(URI.parse("#{MYSQL_BASE_URL}"))

        Logger.log("available clients:")
        most_recent = ""
        response.lines.each do |line|
          if REGEX =~ line
            Logger.log("#{$1}")
            most_recent = $1 if $1 > most_recent
          end
        end

        most_recent
      end
    end
  end
end
