# LifxDash

[![Gem](https://img.shields.io/gem/v/lifx_dash.svg?style=flat)](http://rubygems.org/gems/lifx_dash)
[![Travis](https://img.shields.io/travis/com/matthutchinson/lifx_dash/master.svg?style=flat)](https://travis-ci.com/matthutchinson/lifx_dash)
[![Depfu](https://img.shields.io/depfu/matthutchinson/lifx_dash.svg?style=flat)](https://depfu.com/github/matthutchinson/lifx_dash)
[![Maintainability](https://api.codeclimate.com/v1/badges/2fc8264df43f49c3fc41/maintainability)](https://codeclimate.com/github/matthutchinson/lifx_dash/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2fc8264df43f49c3fc41/test_coverage)](https://codeclimate.com/github/matthutchinson/lifx_dash/test_coverage)

![Amazon LIFX Dash Button](http://matthutchinson.github.io/lifx_dash/images/lifx_dash.png)

`lifx_dash` is a simple command-line tool to monitor your network for [Amazon
Dash button](https://www.amazon.com/Dash-Buttons/b?ie=UTF8&node=10667898011)
presses and toggle [LIFX](http://www.lifx.com) lights ON and OFF. The tool
provides two commands, `monitor` and `snoop`.

Use `snoop` to listen for Dash presses on your network, and identify the
button's MAC address.

Use `monitor` (with a MAC address and LIFX HTTP API token) to respond to
presses, and toggle your lights ON and OFF. You can optionally pass a bulb
selector, or choose to daemonize the `monitor` process.

A `config` command also exists, allowing you to set default options for
`monitor` and `snoop`.

## Requirements

`lifx_dash` requires at least one LIFX bulb, and any Amazon Dash button. You
will also need a wifi network and root access to sniff packets on your network
adaptor.

This gem uses [packet_fu](https://rubygems.org/gems/packetfu) which in turn
requires the [libpcap](http://www.tcpdump.org) library. This is probably already
available on your machine, if not download the [latest
release](http://www.tcpdump.org/#latest-release) or install with your package
manager e.g.:

    sudo apt-get install libpcap0.8-dev  # UNIX
    brew install libpcap                 # homebrew on OSX

`lifx_dash` is distributed via [RubyGems](https://rubygems.org) and requires
[Ruby](https://www.ruby-lang.org) >= 2.0.0.

## Installation

    gem install lifx_dash

The `lifx_dash` command will now be available in your PATH.

### Dash Button Setup

Follow Amazon's Dash button setup steps, but **stop** before choosing a product
to purchase. Pressing the button should pulse white while connecting to wi-fi,
then flash orange. If necessary, you can [factory
reset](https://www.amazon.com/gp/help/customer/display.html?nodeId=201746400)
your button and start the setup from scratch.

Next use the `snoop` command to determine the button's MAC address:

    $ sudo lifx_dash snoop -i en0

This will listen on network interface 'en0' for Dash button packets. Take a note
of the MAC address that's logged when you press. To list network interfaces on
your machine use:

    $ ifconfig -l

### LIFX Bulb Setup

Create a [personal token](https://cloud.lifx.com/settings) for the LIFX HTTP
API.

By default `lifx_dash` will toggle _ALL_ bulbs. To toggle a specific light you
will need to find the LIFX Bulb ID.

Visit the LIFX API [list
lights](https://api.developer.lifx.com/docs/list-lights) doc and use the 'Try It
Out' form with your token. Details for all bulbs on your network will be shown
along with their IDs (in JSON format).

Or call the API directly with this curl command:

    $ curl "https://api.lifx.com/v1/lights/all" -H "Authorization: Bearer LIFX_API_TOKEN"

## Usage

To start the `lifx_dash` monitor:

    $ sudo lifx_dash monitor --token=LIFX_API_TOKEN --mac-address=DASH_MAC_ADDRESS --selector='all' --iface=en0
    Starting lifx_dash monitor ...

This starts a long-running process listening on 'en0', for button presses (from
the given MAC address). When a press occurs, the monitor will toggle all LIFX
bulbs.

Only the `--mac-address` and `--token` options are required, by default
`--selector=all` and `--iface=en0`. You can also use short-form flag options
like so:

    $ sudo lifx_dash monitor -t LIFX_API_TOKEN -m DASH_MAC_ADDRESS -s 'all' -i en0

### Running as a Daemon

Use the `-d` switch (or `--daemonize`) to run `monitor` as a daemon:

    $ sudo lifx_dash monitor -t LIFX_API_TOKEN -m DASH_MAC_ADDRESS -s 'all' -i en0 -d
    [17099] Starting lifx_dash ... (daemon logging to /tmp/lifx_dash.log)

The command will log to `/tmp/lifx_dash.log` by default (creating the file and
folder if it does not exist). Use `-l` or `--log-file` to override this
location.

## Configuration

You can save option defaults using the `config` command:

    $ lifx_dash config
    Configuring lifx_dash ...

You will be prompted for values for each option and your choices will be stored
at `~/.lifx_dash.rc.yml`.

An empty answer will mean no value is set, and the option reverts to it's
default. Passing options on the command-line always takes precedence over
your saved configuration.

You can inspect the current configuration file options with:

    $ lifx_dash config --show

## Help

You can get help in number of ways, for example:

    $ lifx_dash help
    $ lifx_dash help monitor
    $ lifx_dash snoop -h
    $ lifx_dash config --help

The gem also comes packaged with its own [man
page](http://htmlpreview.github.io/?https://raw.githubusercontent.com/matthutchinson/lifx_dash/master/man/lifx_dash.1.html).
You'll need [gem-man](https://github.com/defunkt/gem-man) to view this from your
command line.

## Troubles?

If you think something is broken or missing, do raise a new
[issue](https://github.com/matthutchinson/lifx_dash/issues). Please remember to
take a moment and check it hasn't already been raised (and possibly closed).

## What does the code do?

This gem uses the [PacketFu](https://rubygems.org/gems/packetfu) gem (and
[libpcap](https://sourceforge.net/projects/libpcap/) under the hood) to monitor
data packets on your network. This packet stream filters for
[DHCP](https://wiki.wireshark.org/DHCP) packets (sent from 0.0.0.0). See
[below](https://github.com/matthutchinson/lifx_dash#packet-detection)
for more details on packet detection.

When a valid packet is detected with a known source MAC address, the LIFX HTTP
API [toggle-power](https://api.developer.lifx.com/docs/toggle-power) endpoint is
requested, with a selector and authorization header.

The [GLI](http://naildrivin5.com/gli/) command line framework is used to define
the commands and options.
[MiniTest](https://rubygems.org/gems/minitest/versions/5.7.0) and
[Aruba](https://rubygems.org/gems/aruba) are used for testing.

## Packet detection

Using [WireShark](https://www.wireshark.org) to monitor the network it appears
that;

* older buttons send an ARP packet followed by one or more DHCP packets
* newer buttons send one or more DHCP packets

To detect packets on both devices it should only be necessary to look for
DHCP packets; this can be done with the following filter:

```
udp and src port 68 and dst port 67 and udp[247:4] == 0x63350103 and src host 0.0.0.0
```

However since DHCP packets appear to arrive in bursts of 2, the
[Capturer](https://github.com/matthutchinson/lifx_dash/blob/master/lib/lifx_dash/capturer.rb)
only acts on packets that have an even IP
[ID](https://tools.ietf.org/html/rfc6864) field.

## Contributing

Bug [reports](https://github.com/matthutchinson/lifx_dash/issues) and [pull
requests](https://github.com/matthutchinson/lifx_dash/pulls) are welcome on
GitHub.

When submitting pull requests, please remember to add tests covering the new
behaviour, and ensure all tests are passing on [Travis
CI](https://travis-ci.com/matthutchinson/lifx_dash). Read the [contributing
guidelines](https://github.com/matthutchinson/lifx_dash/blob/master/CONTRIBUTING.md)
for more details.

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [Contributor
Covenant](http://contributor-covenant.org) code of conduct. See
[here](https://github.com/matthutchinson/lifx_dash/blob/master/CODE_OF_CONDUCT.md)
for more details.

## Development

After checking out the repo, run `bin/setup`, this will install dependencies,
and re-generate the man page and docs. Then, run `bundle exec rake` to run all
tests (and generate a coverage report). You can run unit or feature tests
separately with:

    bundle exec rake test
    bundle exec rake features

You can also run `bin/console` for an interactive prompt that will allow you to
experiment with the gem code.

## Future Work

Work in progress is usually mentioned at the top of the
[CHANGELOG](https://github.com/matthutchinson/lifx_dash/blob/master/CHANGELOG.md).
If you'd like to get involved in contributing, here are some ideas:

* Validation of all command line flag values, iface/mac/token etc.
* More unit test coverage
* Aruba features covering the happy paths for all commands
* Smarter config, auto-snoop, list bulbs with names and choose id
* Show existing values in config, when configuring, allowing edits (with readline)
* More Rdoc documentation on command classes
* New optional flag for the configuration file location
* Handle CTRL-C and kill signals with better exit/cleanup messages
* Use LIFX LAN API (with a command switch to choose LAN/HTTP)

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

## Links

* [Travis CI](http://travis-ci.com/matthutchinson/lifx_dash)
* [Maintainability](https://codeclimate.com/github/matthutchinson/lifx_dash/maintainability)
* [Test Coverage](https://codeclimate.com/github/matthutchinson/lifx_dash/test_coverage)
* [RDoc](http://rdoc.info/projects/matthutchinson/lifx_dash)
* [Wiki](http://wiki.github.com/matthutchinson/lifx_dash/)
* [Issues](http://github.com/matthutchinson/lifx_dash/issues)
* [Report a bug](http://github.com/matthutchinson/lifx_dash/issues/new)
* [Gem](http://rubygems.org/gems/lifx_dash)
* [GitHub](http://github.com/matthutchinson/lifx_dash)

## Who's Who?

* [LifxDash](http://github.com/matthutchinson/lifx_dash) by [Matthew Hutchinson](http://matthewhutchinson.net)
* Inspired by this [hack](http://tinyurl.com/zba3da2) from [Ted Benson](https://twitter.com/edwardbenson)
