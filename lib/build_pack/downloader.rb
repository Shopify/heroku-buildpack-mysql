module BuildPack
  class Downloader
    MYSQL_BASE_URL = "http://security.debian.org/pool/updates/main/m/mysql-5.5"
    REGEX = /.*(mysql-client-5\.5_5\.5\...-0\+deb.u._amd64.deb).*/

    class << self
      def download_latest_client_to(path)
        client = most_recent_client

        puts "-----> Downloading MySQL Client package"
        File.open(path, 'w+').write(Net::HTTP.get(URI.parse("#{MYSQL_BASE_URL}/#{client}")))
      end

      def most_recent_client
        most_recent = ""
        response = Net::HTTP.get(URI.parse("#{MYSQL_BASE_URL}"))
        response.lines.each do |line|
          if REGEX =~ line
            if $1 > most_recent
              most_recent = $1
            end
          end
        end

        most_recent
      end
    end
  end
end
