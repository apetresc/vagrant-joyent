require "vagrant"

module VagrantPlugins
  module Joyent
    module Errors
      class VagrantJoyentError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_joyent.errors")
      end

      class FogError < VagrantJoyentError
        error_key(:fog_error)
      end

      class RsyncError < VagrantJoyentError
        error_key(:rsync_error)
      end
    end
  end
end
