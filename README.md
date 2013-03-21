# Vagrant::Joyent

vagrant-joyent is a Vagrant provider for the Joyent Cloud and SmartDatacenter

## Installation

    $ git clone https://github.com/someara/vagrant-joyent/
    $ cd vagrant-joyent
    $ gem build vagrant-joyent.gemspec ; 
    $ vagrant plugin install vagrant-joyent-0.1.0.gem 
    $ vagrant box add dummy.box

## Usage

Check out a chef-repo with a Joyent compatible Vagrantfile, then run "vagrant up"

    $ git clone https://github.com/someara/vagrant-joyent-hello_world-repo 
    $ cd vagrant-joyent-hello_world-repo
    $ vagrant up --provider=joyent
    $ vagrant provision
    $ vagrant ssh
    $ vagrant destroy

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
