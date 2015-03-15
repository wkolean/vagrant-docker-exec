module VagrantPlugins
  module DockerExec
    class Command < Vagrant.plugin("2", "command")
      def self.synopsis
        "open a shell in a running docker container"
      end

      def execute

        options = {}
        options[:detach]    = false
        options[:pty]       = true
        options[:stdin]     = true
        options[:new_line]  = false

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant docker-shell [container]"
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        target_opts = { provider: :docker }
        target_opts[:single_target] = options[:pty]

        with_target_vms(argv, target_opts) do |machine|
          if machine.state.id != :running
            @env.ui.info("#{machine.name.to_s} is not running.")
            next
          end

          command = ["docker", "exec", "-it"]
          command << machine.id.to_s
          command << "bash"

          #machine.provider.driver.execute(*command, options)
          machine.provider.driver.execute(*command, options) do |type, data|
            @env.ui.detail(data.chomp, **options)
          end

        end

        #return 0
      end

    end
  end
end