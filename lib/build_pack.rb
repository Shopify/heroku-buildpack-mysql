require 'fileutils'

module BuildPack
  def self.run(build_dir, cache_dir)
    Installer.install(build_dir, cache_dir)
  end
end

require_relative "build_pack/installer"
