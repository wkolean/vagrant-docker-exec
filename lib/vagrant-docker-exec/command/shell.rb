module VagrantPlugins
  module DockerExec
    class Command < Vagrant.plugin("2", "command")
      def execute
        puts "docker-shell"
        return 0
      end
    end
  end
end