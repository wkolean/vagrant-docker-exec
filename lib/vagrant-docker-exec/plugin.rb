begin
  require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end

module VagrantPlugins
  module DockerExec
    class Plugin < Vagrant.plugin("2")
      name "docker-exec"
      description "The vagrant-docker-exec plugin lets you run commands in a docker container"

      command "docker-exec" do
        require_relative "command/exec"
        Command
      end

      command "docker-shell" do
        require_relative "command/shell"
        Command
      end

      # This initializes the internationalization strings.
      def self.setup_i18n
        I18n.load_path << File.expand_path("locales/en.yml", DockerExec.source_root)
        I18n.reload!
      end

    end
  end
end