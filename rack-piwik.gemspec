# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|

  s.name        = "rack-piwik"
  s.version     = File.read('VERSION').to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Maxwell Salzberg"]
  s.email       = ["maxwell@joindiaspora.com"]
  s.homepage    = "https://github.com/maxwell/rack-piwik"
  s.summary     = "Rack middleware to inject the Piwik tracking code into outgoing responses. Adapted from rack-google-analytics"
  s.description = "Simple Rack middleware for implementing Piwik Analytics tracking in your Ruby-Rack based project."

  s.files        = Dir.glob('lib/**/*') + %w(README.md LICENSE)
  s.files        += Dir.glob('test/**/*')
  s.require_path = 'lib'
end
