hibiscus-ruby is a Ruby API client for the HBCI-compliant Hibiscus payment server (http://www.willuhn.de/products/hibiscus-server).
It will be able to create bookings, and read and search statement lines.

# Mutation testing example:

> mutant --include lib --require hibiscus/client --use rspec --fail-fast Hibiscus::Client

# Travis build status:

[![Build Status](https://travis-ci.org/phillipoertel/hibiscus-ruby.svg)](https://travis-ci.org/phillipoertel/hibiscus-ruby)