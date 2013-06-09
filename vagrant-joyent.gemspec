$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-joyent/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-joyent"
  s.version       = VagrantPlugins::Joyent::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = "Sean OMeara"
  s.email         = "someara@opscode.com"
  s.homepage      = "http://www.vagrantup.com"
  s.summary       = "Enables Vagrant to manage machines in Joyent cloud and SDC"
  s.description   = "Enables Vagrant to manage machines in Joyent cloud and SDC"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vagrant-joyent"

  s.add_runtime_dependency "fog", "~> 1.10"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-core", "~> 2.12"
  s.add_development_dependency "rspec-expectations", "~> 2.12"
  s.add_development_dependency "rspec-mocks", "~> 2.12"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec`.split("\n")
  s.executables   = `git ls-files -- bin`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'
end
