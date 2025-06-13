class Auth
  USERS = {
    ENV['USER_ADMIN'] => ENV['PASS_ADMIN']
  }
  JWT_SECRET = ENV['JWT_SECRET']

  def login(request, response)
    begin
      params = JSON.parse(request.body.read)
    rescue JSON::ParserError
      response.status = 400
      response.write({ error: 'Invalid JSON' }.to_json)
      return response.finish
    end
    user = params['user']
    password = params['password'].to_s

    if USERS[user] == password
      response.status = 200
      response.write({token: encode_token(user)}.to_json)
    else
      response.status = 401
      response.write({error: 'wrong user or password'}.to_json)
    end
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
    begin
      payload = decode_token(token)[0]
      exp_time = Time.at(payload['exp']).utc
      payload['exp_readable'] = exp_time.strftime("%B %d, %Y %H:%M UTC")
      payload
    rescue JWT::ExpiredSignature, JWT::DecodeError
      nil
    end
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
    JWT.decode(token, JWT_SECRET, true, { algorithm: 'HS256' })
  end
end