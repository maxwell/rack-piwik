require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack'
require 'rack/test'
require File.expand_path('../../lib/rack/piwik',__FILE__)

class Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app; Rack::Lint.new(@app); end
  
  def mock_app(options)
    main_app = lambda { |env|
      request = Rack::Request.new(env)
      case request.path
      when '/head_only' then [200,{ 'Content-Type' => 'application/html' },['<head>head only</head>']]
      when '/arbitrary.xml' then [200,{'Content-Type' => 'application/xml'}, ['xml only']]
      when '/body_only' then [200,{'Content-Type' => 'application/html'} ,['<body>body only</body>']]
      else [404,'Nothing here']
      end
    }

    builder = Rack::Builder.new
    builder.use Rack::Piwik, options
    builder.run main_app
    @app = builder.to_app
  end
end
