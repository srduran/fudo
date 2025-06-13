class AsyncWorker
  def initialize store
    @store = store
  end

  def enqueue(request, response)
    body = JSON.parse(request.body.read)
    name = body['name']

    Thread.new do
      sleep 5
      @store.add(name)
    end

    response.status = 202
    response.write({ message: 'This product will be created in a few seconds' }.to_json)
  end

end