### Introduction 

hibiscus-ruby is a Ruby API client for the HBCI-compliant [Hibiscus payment server](http://www.willuhn.de/products/hibiscus-server).

### Requirements

- Ruby 1.9 or higher
- a running instance of [hibiscus-server](http://www.willuhn.de/products/hibiscus-server/), configured for your HBCI-accessible bank accounts. 
  **For security reasons, it is highly recommended to run the server locally!**

### How to use

	> irb -Ilib

	require 'hibiscus-ruby'

	# configure the client
	Hibiscus::Client.config = { 
	  password: 'your hibiscus server password'
	}
	# get the list known accounts
	p Hibiscus::Account.new.all

Options you can pass to `Hibiscus::Client.config`:

* username (defaults to `admin`)
* password (is unset by default)
* base_uri (defaults to `https://localhost:8080/webadmin/rest/hibiscus`)
* verify_ssl (defaults to `false`. hibiscus-server uses an invalid SSL Certificate, which should be fine in 99% of it's use cases)

### API Documentation 

For now, please have a look at the classes in `lib/hibiscus` to find out what they can do.
The specs should be helpful documentation as well.

### Running the tests

rspec unit tests: 

> rake

Mutation tests (using [mutant](https://github.com/mbj/mutant)):

> rake spec:mutation

### Travis build status and Gem badge

[![Build Status](https://travis-ci.org/phillipoertel/hibiscus-ruby.svg)](https://travis-ci.org/phillipoertel/hibiscus-ruby)
[![Gem Version](https://badge.fury.io/rb/hibiscus-ruby.svg)](http://badge.fury.io/rb/hibiscus-ruby)

### License

Released under the [MIT License](http://opensource.org/licenses/MIT).

### Todos

- clean up resources and write unit tests
- write integration tests against the Hibiscus server
- set up nice references, like Account.find(1).statement_line
- make Transfer#create nicer (Terminüberweisung)
- add sanity checks to Transfer#create
- convert server errors (Java Exceptions) into corresponding Ruby exceptions

### Done

- figure out why Transfer#create doesn't work yet (Hibiscus Server doesn't do them with PIN/TAN)
- document how to use the client and set default config
- make it a gem

