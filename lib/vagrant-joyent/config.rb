#: utf-8 -*-
require "vagrant"

module VagrantPlugins
  module Joyent
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :joyent_username
      attr_accessor :joyent_password
      attr_accessor :joyent_api_url
      attr_accessor :dataset
      attr_accessor :flavor
      attr_accessor :node_name
      attr_accessor :ssh_username
      attr_accessor :ssh_private_key_path

      def initialize(datacenter_specific=false)
        @joyent_username    = UNSET_VALUE
        @joyent_password    = UNSET_VALUE
        @joyent_api_url     = UNSET_VALUE
        @dataset            = UNSET_VALUE
        @flavor             = UNSET_VALUE
        @node_name          = UNSET_VALUE
        @ssh_username       = UNSET_VALUE
        @ssh_private_key_path = UNSET_VALUE
      end
      
      #-------------------------------------------------------------------
      # Internal methods.
      #-------------------------------------------------------------------
            
      def finalize!
        # API
        @joyent_username = nil if @joyent_username == UNSET_VALUE
        @joyent_password = nil if @joyent_password == UNSET_VALUE
        @joyent_api_url  = nil if @joyent_api_url  == UNSET_VALUE

        # Machines
        @dataset = nil if @dataset == UNSET_VALUE
        @flavor = "Small 1GB" if @instance_type == UNSET_VALUE
        @node_name = nil if @node_name == UNSET_VALUE
        @ssh_username = nil if @ssh_username == UNSET_VALUE
        @ssh_private_key_path = nil if @ssh_private_key_path == UNSET_VALUE

      end

      def validate(machine)
        config = self.class.new(true)
        
        errors = []        
        errors << I18n.t("vagrant_joyent.config.joyent_username_required") if config.joyent_username.nil?
        errors << I18n.t("vagrant_joyent.config.joyent_password_required") if config.joyent_password.nil?
        errors << I18n.t("vagrant_joyent.config.joyent_api_url_required") if config.joyent_api_url.nil?        
        errors << I18n.t("vagrant_joyent.config.dataset_required") if config.dataset.nil?
        errors << I18n.t("vagrant_joyent.config.flavor_required") if config.flavor.nil?
        errors << I18n.t("vagrant_joyent.config.node_name_required") if config.node_name.nil?
        errors << I18n.t("vagrant_joyent.config.ssh_username_required") if config.ssh_username.nil?
        errors << I18n.t("vagrant_joyent.config.ssh_private_key_path_required") if config.ssh_private_key_path.nil?
        { "Joyent Provider" => errors }
      end
    end    
  end
end
