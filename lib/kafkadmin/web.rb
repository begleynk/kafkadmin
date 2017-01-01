require 'json'
require 'kafkadmin/web/create_topic_action'
require 'kafkadmin/web/delete_topic_action'

module Kafkadmin
  class Web < Sinatra::Base

    configure do
      enable :logging
      use Rack::CommonLogger, SemanticLogger[Web]

      # Better debugging for tests
      if ENV['RACK_ENV'] == 'test'
        set :raise_errors, true
        set :show_exceptions, false
      end
    end

    get '/healthcheck' do
      status 200
      content_type 'application/json'

      { status: 'ok' }.to_json
    end

    post '/topics' do
      content_type 'application/json'

      args = {
        name:               params["name"],
        replication_factor: params["replication_factor"],
        partitions:         params["partitions"]
      }

      action = CreateTopicAction.new(args)
      action.execute!

      if action.success?
        status 201
      else
        status 422
      end
      action.response.to_json
    end

    delete '/topics/:name' do
      action = DeleteTopicAction.new(name: params[:name])
      action.execute!

      if action.success?
        status 200
      else
        status 422
      end
      body action.response.to_json
    end
  end
end
