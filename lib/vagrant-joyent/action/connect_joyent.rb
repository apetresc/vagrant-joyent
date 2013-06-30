require "fog"
require "log4r"
require 'pry'

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

          binding.pry
          
          @logger.info("Connecting to Joyent...")
          env[:joyent_compute] = Fog::Compute.new({
              :provider => 'Joyent',
              :joyent_username => env[:machine].provider_config.username,
              :joyent_keyname => env[:machine].provider_config.keyname,
              :joyent_file => env[:machine].provider_config.keyname,
              :joyent_url => env[:machine].provider_config.api_url,
              :ssl_verify_peer => env[:machine].provider_config.ssl_verify_peer
            })

          binding.pry
          
          @app.call(env)
        end
      end
    end
  end
end
