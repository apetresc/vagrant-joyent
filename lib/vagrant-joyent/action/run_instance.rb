require "log4r"
require 'vagrant/util/retryable'
require 'vagrant-joyent/util/timer'

module VagrantPlugins
  module Joyent
    module Action

      # This runs the configured instance.
      class RunInstance
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_joyent::action::run_instance")
        end

        def call(env)
          # Initialize metrics if they haven't been
          env[:metrics] ||= {}

          # Get the configs
          dataset = env[:machine].provider_config.dataset
          flavor = env[:machine].provider_config.flavor
          node_name = env[:machine].provider_config.node_name || env[:machine].name
          keyname = env[:machine].provider_config.joyent_keyname
          boot_timeout = env[:machine].provider_config.boot_timeout || 2

          # Launch!
          env[:ui].info(I18n.t("vagrant_joyent.launching_instance"))
          env[:ui].info(" -- Flavor: #{flavor}")
          env[:ui].info(" -- Dataset: #{dataset}")
          env[:ui].info(" -- Node name: #{node_name}")
          env[:ui].info(" -- Key name: #{keyname}")

          begin
            options = {
              :name             => node_name,
              :dataset          => dataset,
              :package          => flavor
            }

            server = env[:joyent_compute].servers.create(options)

          rescue Fog::Compute::Joyent::NotFound => e
            raise Errors::FogError, :message => e.message
          rescue Fog::Compute::Joyent::Error => e
            raise Errors::FogError, :message => e.message
          end

          # Immediately save the ID since it is created at this point.
          env[:machine].id = server.id

          # Wait for the instance to be ready first
          env[:metrics]["instance_ready_time"] = Util::Timer.time do
            env[:ui].info(I18n.t("vagrant_joyent.waiting_for_ready"))
            retryable(:on => Fog::Errors::TimeoutError, :tries => 30) do
              # If we're interrupted don't worry about
              # waiting
              next if env[:interrupted]

              # Wait for the server to be ready
              server.wait_for(boot_timeout) { ready? }
            end
          end

          @logger.info("Time to instance ready: #{env[:metrics]["instance_ready_time"]}")
 
          if !env[:interrupted]
            env[:metrics]["instance_ssh_time"] = Util::Timer.time do
              # Wait for SSH to be ready.
              env[:ui].info(I18n.t("vagrant_joyent.waiting_for_ssh"))
              while true
                # If we're interrupted then just back
                # out
                break if env[:interrupted]
                break if env[:machine].communicate.ready?
                sleep 2
              end
            end

            @logger.info("Time for SSH ready: #{env[:metrics]["instance_ssh_time"]}")

            # Ready and booted!
            env[:ui].info(I18n.t("vagrant_joyent.ready"))
          end

          # Terminate the instance if we were interrupted
          terminate(env) if env[:interrupted]

          @app.call(env)
        end

        def recover(env)
          return if env["vagrant.error"].is_a?(Vagrant::Errors::VagrantError)

          if env[:machine].provider.state.id != :not_created
            # Undo the import
            terminate(env)
          end
        end

        def terminate(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Action.action_destroy, destroy_env)
        end
      end
    end
  end
end


