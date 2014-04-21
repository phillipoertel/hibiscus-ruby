## Introduction 

hibiscus-ruby is a Ruby API client for the HBCI-compliant [Hibiscus payment server](http://www.willuhn.de/products/hibiscus-server).

## Requirements

- Ruby 1.9 or higher
- a running instance of [hibiscus-server](http://www.willuhn.de/products/hibiscus-server/), configured for your HBCI-accessible bank accounts. 
  **For security reasons, it is highly recommended to run the server locally!**

## Quick start

	> gem install hibiscus-ruby --pre
	> irb

	require 'hibiscus-ruby'

	# configure the client
	Hibiscus::Client.config = { 
	  password: 'your hibiscus server password'
	}

	# get all known accounts
	p Hibiscus::Account.new.all

## API Documentation 

### Example rake tasks

Each resource method has an example rake task in the [Rakefile](https://github.com/phillipoertel/hibiscus-ruby/blob/master/Rakefile), so have a look at those first (list all examples with `rake -T examples`).

### Hibiscus::Client

#### `.config = config_hash`

Possible options:

* `:username` (defaults to `admin`)
* `:password` (is unset by default)
* `:base_uri` (defaults to `https://localhost:8080/webadmin/rest/hibiscus`)
* `:verify_ssl` (defaults to `false`. hibiscus-server uses an invalid SSL Certificate, which should be fine for 99% of it's use cases)

**Important**: of course the client needs to be configured before anything else will work.

### Hibiscus::Account

#### `#all`

Returns an array of all accounts configured in Hibiscus.

### Hibiscus::StatementLine

#### #latest(hibiscus_account_id, days = 30)

Returns the latest statement lines ("bookings" / transactions) on the given account. 
`hibiscus_account_id` is the account id that hibiscus-server has assigned, not the actual account number.

#### #search(string)

Returns the statement lines ("bookings" / transactions) which contain the given string.

### Hibiscus::Transfer

#### #create(attributes)

Create a transfer / booking.

Not implemented yet.

#### #delete(id)

Delete a transfer / booking.

Not implemented yet.

#### #pending

Show transfers that Hibiscus hasn't performed, yet (hibiscus-server syncs every 180 minutes by default).

Not implemented yet.

### Hibiscus::Jobs

#### #pending

Show sync jobs (like fetching new statement lines for the accounts) that Hibiscus hasn't performed, yet (hibiscus-server syncs every 180 minutes by default).

Not implemented yet.

## Running the tests

rspec unit tests: 

> rake

Mutation tests (using [mutant](https://github.com/mbj/mutant)):

> rake spec:mutation

## Badges :-)

[![Build Status](https://travis-ci.org/phillipoertel/hibiscus-ruby.svg)](https://travis-ci.org/phillipoertel/hibiscus-ruby)
[![Gem Version](https://badge.fury.io/rb/hibiscus-ruby.svg)](http://badge.fury.io/rb/hibiscus-ruby)

## License

Released under the [MIT License](http://opensource.org/licenses/MIT).

## Todos

- raise a meaningful exception when the client isn't configured
- raise a meaningful exception when the client can't access the server (invalid data, server not running)
- write integration tests
- implement Account.find(1).statement_lines
- implement remaining resource methods
