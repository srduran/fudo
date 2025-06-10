require 'json'
require_relative 'auth'
require_relative 'product_store'
require 'rack'

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
      @product_store.list(request, response)
    when ['/products', 'POST']
      @product_store.create(request, response)
    when ['/authors', 'GET']
      response['Cache-Control'] = 'public, max-age=86400'
      response.write(File.read('static/AUTHORS'))
      response['Content-Type'] = 'text/plain'
    else
      response.status = 404
      response.write({ error: 'Not Found' }.to_json)
    end

    response.finish
  end
end