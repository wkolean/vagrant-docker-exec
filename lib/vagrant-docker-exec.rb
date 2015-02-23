require "pathname"

require "vagrant-docker-exec/plugin"

module VagrantPlugins
  module DockerExec
    lib_path = Pathname.new(File.expand_path("../vagrant-docker-exec", __FILE__))
    #autoload :Errors, lib_path.join("errors")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end