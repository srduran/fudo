class Auth
  def login(request, response)
    response.write({ message: 'Login successful' }.to_json)
  end
end