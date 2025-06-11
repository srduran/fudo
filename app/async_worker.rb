class AsyncWorker
  def initialize store
    @store = store
  end

  def enqueue(request, response)
    begin
      body = JSON.parse(request.body.read)
      name = body['name']
    rescue JSON::ParserError
      response.status = 400
      response.write({ error: 'Invalid JSON' }.to_json)
      return response.finish
    end

    if name.nil? || name.empty?
      response.status = 400
      response.write({ error: 'Name is required' }.to_json)
      return response.finish
    end

    Thread.new do
      sleep 5
      @store.add(name)
    end

    response.status = 202
    response.write({ message: 'This product will be created in a few seconds' }.to_json)
    response.finish
  end

end