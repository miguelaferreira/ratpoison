#!/bin/bash -x

source ~/.bashrc

/usr/local/rvm/bin/rvm --default use 2.1.1

set -e

bundle install

bundle exec foodcritic .

bundle exec rubocop

# Runs all RSpec based tests: rspec, chefspec, serverspec, etc
bundle exec rspec

export KITCHEN_LOCAL_YAML=.kitchen.ci.yml 
bundle exec kitchen test
bundle exec kitchen destroy
