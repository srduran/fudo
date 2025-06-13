class MainApp
  def initialize
    @auth = Auth.new
    @product_store = ProductStore.new
    @worker = AsyncWorker.new(@product_store)
  end

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    method = request.request_method
    path = request.path
    response['Content-Type'] = 'application/json'
    response['Accept-Encoding'] = request.env['HTTP_ACCEPT_ENCODING'] || ''

    case [method, path]
    when ['POST', '/login']
      @auth.login(request, response)
    when ['GET', '/products']
      return @auth.unauthorized(response) unless @auth.authenticated?(request)
      @product_store.list(response)
    when ['POST', '/products']
      return @auth.unauthorized(response) unless @auth.authenticated?(request)
      @worker.enqueue(request, response)
    when ['GET', '/authors']
      response.status = 200
      response['Cache-Control'] = 'max-age=86400'
      response.write(File.read('static/AUTHORS'))
      response['Content-Type'] = 'text/plain'
    when ['GET', '/openapi']
      response.status = 200
      response['Cache-Control'] = 'no-store'
      response.write(File.read('static/openapi.yaml'))
      response['Content-Type'] = 'text/yaml'
    when ['GET', '/me']
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