#: utf-8 -*-
require "vagrant"

module VagrantPlugins
  module Joyent
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :username
      attr_accessor :password
      attr_accessor :keyname
      attr_accessor :keyfile
      attr_accessor :api_url
      attr_accessor :dataset
      attr_accessor :flavor
      attr_accessor :node_name
      attr_accessor :ssh_username
      attr_accessor :ssl_verify_peer

      def initialize(datacenter_specific=false)
        @username    = UNSET_VALUE
        @password    = UNSET_VALUE
        @keyname    = UNSET_VALUE
        @keyfile    = UNSET_VALUE
        @api_url     = UNSET_VALUE
        @ssl_verify_peer = UNSET_VALUE
        @dataset            = UNSET_VALUE
        @flavor             = UNSET_VALUE
        @node_name          = UNSET_VALUE
        @ssh_username       = UNSET_VALUE
      end

      #-------------------------------------------------------------------
      # Internal methods.
      #-------------------------------------------------------------------

      def finalize!
        # API
        if @username == UNSET_VALUE
          @username = ENV['JOYENT_USERNAME'] || ENV['SDC_ACCOUNT'] || nil
        end

        if @keyname == UNSET_VALUE
          @keyname = ENV['SDC_KEY_ID'] || nil
        end

        if @keyfile == UNSET_VALUE
          @keyfile = ENV['JOYENT_SSH_PRIVATE_KEY_PATH'] || ENV['SDC_KEY'] || nil
        end

        if @password == UNSET_VALUE
          @password = ENV['JOYENT_PASSWORD'] || nil
        end

        if @api_url == UNSET_VALUE
          @api_url = ENV['JOYENT_API_URL'] || ENV['SDC_URL'] || 'https://us-east-1.api.joyentcloud.com'
        end

        # SSL
        @ssl_verify_peer = true if @ssl_verify_peer = UNSET_VALUE

        # Machines
        @dataset = nil if @dataset == UNSET_VALUE
        @flavor = 'Small 1GB' if @flavor == UNSET_VALUE
        @node_name = 'vagrant-joyent' if @node_name == UNSET_VALUE
        @ssh_username = 'root' if @ssh_username == UNSET_VALUE
      end

      def validate(machine)
        config = self.class.new(true)

        errors = []
        errors << I18n.t("vagrant_joyent.config.username_required") if config.username.nil?
        errors << I18n.t("vagrant_joyent.config.keyname_required") if config.keyname.nil?
        errors << I18n.t("vagrant_joyent.config.keyfile_required") if config.keyfile.nil?
        errors << I18n.t("vagrant_joyent.config.api_url_required") if config.api_url.nil?
        errors << I18n.t("vagrant_joyent.config.dataset_required") if config.dataset.nil?
        errors << I18n.t("vagrant_joyent.config.flavor_required") if config.flavor.nil?
        errors << I18n.t("vagrant_joyent.config.ssh_username_required") if config.ssh_username.nil?

        { "Joyent Provider" => errors }
      end
    end
  end
end
