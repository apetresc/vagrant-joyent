# vagrant-joyent Vagrant plugin

vagrant-joyent is a Vagrant provider for the Joyent Cloud and SmartDatacenter.

## Installation

vagrant-joyent is packaged as a gem on the [central RubyGems
repository](https://rubygems.org/gems/vagrant-joyent), so it can just be
installed with:

    $ vagrant plugin install vagrant-joyent

Chances are, you'll also want to install the basebox for one of the
Joyent images. Currently, only the [base64 13.4.0](http://wiki.joyent.com/wiki/display/jpc2/SmartMachine+Base#SmartMachineBase-13.4.0)
image is supported. It can be installed with:

    $ vagrant box add apetresc/joyent-base64

## Usage

Once the plugin and basebox is installed, you can create a new
Vagrantfile to use with Joyent:

    $ vagrant init apetresc/joyent-base64

Before launching an instance, you must configure your environment with
your Joyent credentials. The following environment variables exist:

  * `JOYENT_USERNAME` (_required_): The Joyent account to create
    instances on behalf of.
  * `JOYENT_SSH_PRIVATE_KEY_PATH` (_optional_): A local path to the
    private key file corresponding to a public key associated with the
    Joyent account. If it's not specified, you will probably be unable
    to SSH into a newly-launched instance.
  * `JOYENT_PASSWORD` (_optional_): The Joyent account password. Only
    required if `JOYENT_SSH_PRIVATE_KEY_PATH` is not provided.
  * `JOYENT_API_URL` (_optional_): The API endpoint to use. This
    corresponds to the Joyent region the instances will be created in.
    Defaults to `https://us-east-1.api.joyentcloud.com`.

You probably want to set these in your shell's profile (`~/.bashrc`,
`~/.zshrc`, etc.) and restart your shell.

To launch a new instance, use:

    $ vagrant up --provider=joyent

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
