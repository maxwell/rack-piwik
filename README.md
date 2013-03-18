# Rack Piwik
Adapted from Rack::Piwik 

Simple Rack middleware to help injecting the Piwik tracking code into the footer of your websites.

## Usage

#### Gemfile:
    gem 'rack-piwik', :require => 'rack/piwik'

#### Sinatra
    ## app.rb
    use Rack::Piwik, :piwik_url => '<url of your piwik site here>', :piwik_id => '<your piwik id here>'

#### Padrino

    ## app/app.rb
    use Rack::Piwik, :piwik_url => '<url of your piwik site here>', :piwik_id => '<your piwik id here>'

#### Rails

    ## application.rb:
    config.gem 'rack-piwik', :lib => 'rack/piwik'
    config.middleware.use Rack::Piwik, :piwik_url => '<url of your piwik site here>', :piwik_id => '<your piwik id here>'

## Thread Safety

This middleware *should* be thread safe. Although my experience in such areas is limited, having taken the advice of those with more experience; I defer the call to a shallow copy of the environment, if this is of consequence to you please review the implementation.

## Change Log

* 0.2.0  Use asynchronous JS tracking code by default
* 0.1.0  Initial Release


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009-2011 Lee Hambley. See LICENSE for details.
With thanks to Ralph von der Heyden http://github.com/ralph/ and Simon `cimm` Schoeters http://github.com/cimm/ - And the biggest hand to Arthur `achiu` Chiu for the huge work that went into the massive 0.9 re-factor.
