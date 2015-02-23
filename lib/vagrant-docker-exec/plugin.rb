begin
  require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end

module VagrantPlugins
  module DockerExec
    class Plugin < Vagrant.plugin("2")
      name "docker-exec"

      command "docker-exec" do
        require_relative "command/exec"
        Command
      end

      command "docker-shell" do
        require_relative "command/shell"
        Command
      end

    end
  end
end