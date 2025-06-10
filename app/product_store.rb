class ProductStore
  def list(request, response)
    response.write({ message: 'Products listed' }.to_json)
  end

  def create(request, response)
    response.write({ message: 'Product created' }.to_json)
  end
end