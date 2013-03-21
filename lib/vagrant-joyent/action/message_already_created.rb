module VagrantPlugins
  module Joyent
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_joyent.already_created"))
          @app.call(env)
        end
      end
    end
  end
end
