require "log4r"

module VagrantPlugins
  module Joyent
    module Action
      # This terminates the running instance.
      class TerminateInstance
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_joyent::action::run_instance")
        end

        def call(env)
          server = env[:joyent_compute].servers.get(env[:machine].id)

          # Destroy the server and remove the tracking ID
          env[:ui].info(I18n.t("vagrant_joyent.terminating"))

          # Machine must be in a stopped state before it's destroyed.
          #
          # More info here:
          #
          #   https://us-west-1.api.joyentcloud.com/docs#DeleteMachine
          #
          server.stop
          server.destroy

          # Wait for server to be completely gone from invetory
          while true do
            ids = []
            env[:joyent_compute].servers.collect.each { |s|
              ids << s.id
            }

            unless ids.include?(env[:machine].id) then
              break
            end
          end

          env[:machine].id = nil

          @app.call(env)
        end
      end
    end
  end
end
