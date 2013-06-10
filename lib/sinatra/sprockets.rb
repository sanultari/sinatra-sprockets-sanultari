require 'sinatra/base'
require 'sprockets'

module Sinatra
  module Sprockets
    def self.registered(app)
      app.set :assets_src, ['assets/js', 'assets/img', 'assets/css']
    end
    def assets(asset_path)
      sprockets = ::Sprockets::Environment.new
      settings.assets_src.each do |src|
        sprockets.append_path src
      end

      absolute_path = asset_path
      absolute_path = "/#{absolute_path}" unless absolute_path.start_with? '/'
      absolute_path = absolute_path[0...-1] if absolute_path.end_with? '/'

      get "#{absolute_path}/*" do |path|
        body = sprockets[path]
        if body.nil?
          404
        else
          content_type body.content_type
          body.to_s
        end
      end
    end
  end

  register Sprockets
end
