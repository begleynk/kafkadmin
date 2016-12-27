
module Kafkadmin
  class Web < Sinatra::Base

    get '/healthcheck' do
      status 200
      content_type 'application/json'

      '{ "status": "ok" }'
    end
  end
end
