require_relative "build_pack/installer"
require_relative "build_pack/downloader"
require_relative "build_pack/logger"

module BuildPack
  def self.run(build_dir, cache_dir)
    Installer.install(build_dir, cache_dir)
  end
end
