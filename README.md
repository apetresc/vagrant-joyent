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

Change the configuration as appropriate (see "Configuration" section).

To launch a new instance, use:

    $ vagrant up --provider=joyent

## Configuration

You may add Joyent-specific configuration to your Vagrantfile like this:

```ruby
    config.vm.provider :joyent do |joyent|
      joyent.username = 'my_example_account'
      joyent.api_url = 'https://us-east-1.api.joyentcloud.com'
    end
```

Some variables are required, others are optional. Most of them (including the
required one) may be set in your environment as environment variables (they are
shown below in all caps: `LIKE_THIS`).

### username
  * _required_ (no default value)
  *  The Joyent account to create instances on behalf of.

### api_url
  * _optional_ (default: `JOYENT_API_URL`, `SDC_URL`, or
    "https://us-east-1.api.joyentcloud.com")
  * Corresponds to the Joyent region the instances will be created in.

### keyfile
  * _optional_ (default: value of `JOYENT_SSH_PRIVATE_KEY_PATH` or `SDC_KEY`
  * A local path to the private SSH key file
    corresponding to a public key associated with the Joyent account. If it's
    not specified, you will probably be unable to SSH into a newly-launched
    instance.

### keyname
  * _optional_ (default: value of `SDC_KEY_ID`)
  * The ID of the SSH key, if there is more than
    one associated with your Joyent account. In reality, this is the SSH
    key's fingerprint (16 octets, hexadecimal, comma-delimited:
    xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx).

### password
  * _not recommended_ (default: `JOYENT_PASSWORD`; environment variable is
    preferable for obvious security reasons)
  * The Joyent account password. Only required if `keyfile` is not provided.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
