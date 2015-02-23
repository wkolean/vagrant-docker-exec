module VagrantPlugins
  module DockerExec
    class Command < Vagrant.plugin("2", "command")
      def execute
        options = {}
        options[:detach] = false
        options[:pty] = false

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant docker-exec [command...]"
          o.separator ""
          o.separator "Options:"
          o.separator ""

          o.on("--[no-]detach", "Run in the background") do |d|
            options[:detach] = d
          end

          o.on("-t", "--[no-]tty", "Allocate a pty") do |t|
            options[:pty] = t
          end
        end

        # Parse out the extra args to send to SSH, which is everything
        # after the "--"
        command     = nil
        split_index = @argv.index("--")
        if split_index
          command = @argv.drop(split_index + 1)
          @argv   = @argv.take(split_index)
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        # Show the error if we don't have "--" _after_ parse_options
        # so that "-h" and "--help" work properly.
        if !split_index
          @env.ui.error(I18n.t("vagrant_docker_exec.exec_command_required"))
          return 1
        end

        target_opts = { provider: :docker }
        target_opts[:single_target] = options[:pty]

        with_target_vms(argv, target_opts) do |machine|
          if machine.state.id != :running
            @env.ui.info("#{machine.name} is not running.")
            next
          end

          # Run it!
          exec_command(machine, options, command)
        end

        return 0
      end

      def exec_command(machine, options, command)

        exec_cmd = %W(docker exec)
        exec_cmd << "-i" << "-t" if options[:pty]
        exec_cmd << options[:name]
        exec_cmd += options[:extra_args] if options[:extra_args]
        exec_cmd.concat(command)

        # Run this interactively if asked.
        exec_options = options
        exec_options[:stdin] = true if options[:pty]

        output = ""
        machine.provider.driver.execute(*cmd, exec_options) do |type, data|
          output += data
        end

      end

    end
  end
end