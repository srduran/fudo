class MainApp
  def initialize
    @auth = Auth.new
    @product_store = ProductStore.new
  end

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response['Content-Type'] = 'application/json'

    case [request.path, request.request_method]
    when ['/login', 'POST']
      @auth.login(request, response)
    when ['/products', 'GET']
      return @auth.unauthorized(response) unless @auth.authenticated?(request)
      @product_store.list(request, response)
    when ['/products', 'POST']
      return @auth.unauthorized(response) unless @auth.authenticated?(request)
      @product_store.create(request, response)
    when ['/authors', 'GET']
      response['Cache-Control'] = 'public, max-age=86400'
      response.write(File.read('static/AUTHORS'))
      response['Content-Type'] = 'text/plain'
    when ['/openapi', 'GET']
      response['Cache-Control'] = 'no-store'
      response.write(File.read('static/openapi.yaml'))
      response['Content-Type'] = 'text/yaml'
    when ['/me', 'GET']
      return @auth.unauthorized(response) unless @auth.authenticated?(request)
      user_data = @auth.get_user_data(request)
      response.write({ 
        user: user_data['user'],
        exp_readable: user_data['exp_readable']
      }.to_json)
    else
      response.status = 404
      response.write({ error: 'Not Found' }.to_json)
    end

    response.finish
  end
end