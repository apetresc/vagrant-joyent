require "pathname"

require "vagrant/action/builder"

module VagrantPlugins
  module Joyent
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin
      
      # This action is called to terminate the remote machine.
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectJoyent
          b.use TerminateInstance
        end
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use Provision
            b2.use SyncFolders
          end
        end
      end
      
      # This action is called to read the SSH info of the machine. The
      # resulting state is expected to be put into the `:machine_ssh_info`
      # key.     
      def self.action_read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectJoyent
          b.use ReadSSHInfo
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state_id`
      # key.
      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectJoyent
          b.use ReadState
        end
      end

      # This action is called to SSH into the machine.
      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            
            b2.use SSHExec
          end
        end
      end

      # This action is called to bring the box up from nothing.
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectJoyent
          b.use Call, IsCreated do |env, b2|
            if env[:result]
              b2.use MessageAlreadyCreated
              next
            end
            
            b2.use TimedProvision
            b2.use SyncFolders
            b2.use WarnNetworks
            b2.use RunInstance
          end
        end
      end

      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :ConnectJoyent, action_root.join("connect_joyent") # check
      autoload :IsCreated, action_root.join("is_created") # check?
      autoload :MessageAlreadyCreated, action_root.join("message_already_created") # check
      autoload :MessageNotCreated, action_root.join("message_not_created") # check
      autoload :ReadSSHInfo, action_root.join("read_ssh_info") # check?
      autoload :ReadState, action_root.join("read_state") # check
      autoload :RunInstance, action_root.join("run_instance") # check
      autoload :SyncFolders, action_root.join("sync_folders") # check
      autoload :TimedProvision, action_root.join("timed_provision") # check
      autoload :WarnNetworks, action_root.join("warn_networks") # check
      autoload :TerminateInstance, action_root.join("terminate_instance") # FIXME
    end
  end
end
