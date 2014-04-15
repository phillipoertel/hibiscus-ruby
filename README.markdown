hibiscus-ruby is a Ruby API client for the HBCI-compliant Hibiscus payment server (http://www.willuhn.de/products/hibiscus-server).
It will be able to create bookings, and read and search statement lines.

### Mutation testing example (all methods of Hibiscus::Client)

> mutant --include lib --require hibiscus/client --use rspec --fail-fast Hibiscus::Client

### Travis build status

[![Build Status](https://travis-ci.org/phillipoertel/hibiscus-ruby.svg)](https://travis-ci.org/phillipoertel/hibiscus-ruby)

### Todos

- make it a gem
- figure out why Transfer#create doesn't work yet
- make Transfer#create nicer (Terminüberweisung)
- add sanity checks to Transfer#create
- clean up resources and write unit tests
- write integration tests against the Hibiscus server
- implement FakeParty (alternative HTTP library usable for debugging / )
- set up nice references, like Account.find(1).statement_lines
- convert server errors (Java Exceptions) into corresponding Ruby exceptions