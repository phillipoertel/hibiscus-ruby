hibiscus-ruby is a Ruby API client for the HBCI-compliant Hibiscus payment server (http://www.willuhn.de/products/hibiscus-server).
It will be able to create bookings, and read and search statement lines.

### Running the tests

rspec unit tests: 

> rake

Mutation tests (using [mutant](https://github.com/mbj/mutant)):

> rake spec:mutation

### Travis build status

[![Build Status](https://travis-ci.org/phillipoertel/hibiscus-ruby.svg)](https://travis-ci.org/phillipoertel/hibiscus-ruby)

### Todos

- make it a gem
- clean up resources and write unit tests
- write integration tests against the Hibiscus server
- set up nice references, like Account.find(1).statement_lines
- make Transfer#create nicer (Terminüberweisung)
- add sanity checks to Transfer#create
- convert server errors (Java Exceptions) into corresponding Ruby exceptions
- implement FakeParty (alternative HTTP library usable for debugging / )

### Done

- figure out why Transfer#create doesn't work yet (Hibiscus Server doesn't do them with PIN/TAN)
