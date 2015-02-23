module VagrantPlugins
  module DockerExec
    class Command < Vagrant.plugin("2", "command")
      def self.synopsis
        "open a shell in a running docker container"
      end

      def execute

        options = {}
        options[:detach]  = false
        options[:pty]     = true
        options[:stdin]   = true

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant docker-shell [container]"
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        target_opts = { provider: :docker }
        target_opts[:single_target] = options[:pty]

        with_target_vms(argv, target_opts) do |machine|
          command = ["docker", "exec", "-it"]
          command << machine.name.to_s
          command << "bash"
          
          output = ""
          machine.provider.driver.execute(*command, options) do |type, data|
            output += data
          end
        end

        return 0
      end

    end
  end
end