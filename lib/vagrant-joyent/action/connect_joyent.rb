require "fog"
require "log4r"

module VagrantPlugins
  module Joyent
    module Action
      # This action connects to Joyent, verifies credentials work, and
      # puts the Joyent connection object into the `:joyent_compute` key
      # in the environment.
      class ConnectJoyent
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_joyent::action::connect_joyent")
        end

        def call(env)

          joyent_username = env[:machine].provider_config.joyent_username
          joyent_keyname = env[:machine].provider_config.joyent_keyname
          joyent_keyfile = env[:machine].provider_config.joyent_keyfile
          joyent_api_url  = env[:machine].provider_config.joyent_api_url

          @logger.info("Connecting to Joyent...")
          env[:joyent_compute] = Fog::Compute.new({
              :provider => 'Joyent',
              :joyent_username => joyent_username,
              :joyent_keyname => joyent_keyname,
              :joyent_keyfile => joyent_keyfile,
              :joyent_url => joyent_api_url
            })

          @app.call(env)
        end
      end
    end
  end
end
