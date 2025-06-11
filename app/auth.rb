class Auth
  USERS = {
    ENV['USER_ADMIN'] => ENV['PASS_ADMIN']
  }
  JWT_SECRET = ENV['JWT_SECRET'] || 'secret_key'

  def login(request, response)
    begin
      body = JSON.parse(request.body.read)
    rescue JSON::ParserError
      response.status = 400
      response.write({ error: 'Invalid JSON' }.to_json)
      return response.finish
    end

    if USERS[body['user']] == body['password'].to_s
      token = encode_token(body['user'])
      response.status = 200
      response['Content-Type'] = 'application/json'
      response.write({ token: token }.to_json)
    else
      response.status = 401
      response.write({ error: 'Invalid credentials' }.to_json)
    end
    response.finish
  end

  def authenticated?(request)
    token = extract_token(request)
    return false unless token
    begin
      decode_token(token)
      true
    rescue JWT::ExpiredSignature, JWT::DecodeError
      false
    end
  end

  def unauthorized(response)
    response.status = 401
    response.write({ error: 'Unauthorized' }.to_json)
    response.finish
  end

  def get_user_data(request)
    token = extract_token(request)
    payload = decode_token(token)[0]

    exp_time = Time.at(payload['exp']).utc
    payload['exp_readable'] = exp_time.strftime("%B %d, %Y %H:%M UTC")
    payload
  rescue
    nil
  end

  def extract_token(request)
    auth_header = request.get_header('HTTP_AUTHORIZATION')
    return nil unless auth_header&.start_with?('Bearer ')
    auth_header.split(' ').last
  end

  def encode_token(user)
    payload = { user: user, exp: Time.now.to_i + 3600 }
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  def decode_token(token)
    begin
      JWT.decode(token, JWT_SECRET, true, { algorithm: 'HS256' })
    rescue JWT::ExpiredSignature
      response.status = 401
      response.write({ error: 'Token expired' }.to_json)
      response.finish
    end
  end
end