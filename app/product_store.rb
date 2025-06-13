class ProductStore
  def initialize
    @products = []
    @mutex = Mutex.new
  end

  def add(name)
    @mutex.synchronize do
      @products << { id: @products.length + 1, name: name }
    end
  end

  def list(response)
    response.status = 200
    response.write({ products: @products }.to_json)
  end
end