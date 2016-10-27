module BuildPack
  class Installer
    class << self
      def install(build_dir, cache_dir)
        setup(build_dir, cache_dir)
        Downloader.download_latest_client_to(@mysql_pkg) unless cached?
        install_client
        cleanup
      end

      private

      def setup(build_dir, cache_dir)
        @bin_path = "#{build_dir}/bin"
        @tmp_path = "#{build_dir}/tmp"
        @mysql_path = "#{@tmp_path}/mysql"
        @mysql_binaries = "#{@mysql_path}/usr/bin"

        @mysql_pkg = "#{cache_dir}/mysql.deb"

        FileUtils.mkdir_p(@bin_path)
        FileUtils.mkdir_p(@tmp_path)
      end

      def cached?
        exists = File.exist?(@mysql_pkg)
        if exists
          puts "-----> Using MySQL Client package from cache"
        end

        exists
      end

      def install_client
        cmd = "dpkg -x #{@mysql_pkg} #{@mysql_path}"
        run_command_with_message(command: cmd, message: "Installing MySQL Client")

        binaries = Dir.glob("#{@mysql_binaries}/*")

        FileUtils.chmod("u=wrx", binaries)
        FileUtils.mv(binaries, @bin_path)
      end

      def run_command_with_message(command:, message:)
        puts "-----> #{message}"
        puts "-----> #{command}"
        output = `#{command}`
        puts output
      end

      def cleanup
        puts "-----> Cleaning up"
        FileUtils.remove_dir(@mysql_path)
      end
    end
  end
end
