require 'json'
require 'kafkadmin/web/create_topic_action'

module Kafkadmin
  class Web < Sinatra::Base

    configure do
      enable :logging
      use Rack::CommonLogger, SemanticLogger[Web]
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
  end
end
