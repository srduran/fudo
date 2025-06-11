require 'rack/utils'

class CorsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['REQUEST_METHOD'] == 'OPTIONS'
      return [
        200,
        cors_headers,
        []
      ]
    end

    status, headers, body = @app.call(env)
    headers.merge!(cors_headers)
    [status, headers, body]
  end

  def cors_headers
    {
      'access-control-allow-origin' => '*',
      'access-control-allow-methods' => 'GET, POST, PUT, DELETE, OPTIONS',
      'access-control-allow-headers' => 'authorization, content-type',
      'access-control-max-age' => '86400'
    }
  end
end