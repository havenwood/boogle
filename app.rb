require 'roda'

require_relative 'lib/boogle'

class App < Roda
  plugin :default_headers, 'Content-Type' => 'application/json'
  plugin :header_matchers
  plugin :json
  plugin :not_allowed

  opts[:boogle] = Boogle.new

  route do |r|
    r.is 'search' do
      r.get do
        r.on(param: 'query') do |query|
          {'matches' => opts[:boogle].search(query)}
        end
      end
    end

    r.is 'index' do
      r.post do
        body = JSON.parse request.body.read
        opts[:boogle].index body['pageId'], body['content']

        # TODO: Create and enable a Roda plugin that supports 1xx, 204, 205,
        # and 304 status codes by removing the Content-Type and Content-Body
        # from the header for Rack::Utils::STATUS_WITH_NO_ENTITY_BODY codes.
        # (Remove the header fields by implementing `RequestMethods#finish`
        # in the plugin.) Then document and uncomment:
        #
        # response.status = 204
      end
    end
  end
end
