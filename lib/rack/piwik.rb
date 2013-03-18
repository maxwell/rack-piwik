require 'rack'
require 'erb'

module Rack

  class Piwik
    DEFAULT = {} 

    def initialize(app, options = {})
      raise ArgumentError, "piwik_url must be present" unless options[:piwik_url] and !options[:piwik_url].empty?
      raise ArgumentError, "piwik_id must be present" unless options[:piwik_id] and !options[:piwik_id].to_s.empty?
      @app, @options = app, DEFAULT.merge(options)
    end

    def call(env); dup._call(env); end

    def _call(env)
      @status, @headers, @response = @app.call(env)
      return [@status, @headers, @response] unless html?
      response = Rack::Response.new([], @status, @headers)
      @response.each { |fragment| response.write inject(fragment) }
      response.finish
    end

    private

    def html?; @headers['Content-Type'] =~ /html/; end

    def inject(response)
      file = 'async'
      @template ||= ::ERB.new ::File.read ::File.expand_path("../templates/#{file}.erb",__FILE__)
      response.gsub(%r{</body>}, @template.result(binding) + "</body>")
    end
  end
end
