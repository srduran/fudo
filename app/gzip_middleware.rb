class GzipMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    
    content_type = headers['Content-Type'].to_s
    accept_encoding = env['HTTP_ACCEPT_ENCODING'] 

    if accept_encoding&.include?('gzip') && content_type&.include?('application/json')
      string_body = ''
      body.each { |part| string_body << part }
      compressed = gzip(string_body)
      headers['Content-Encoding'] = 'gzip'
      headers['Content-Length'] = compressed.bytesize.to_s
      headers['X-Compressed'] = 'true'
      body = [compressed]
    end
    
    [status, headers, body]
  end

  private
  def gzip(string)
    output = StringIO.new
    zipped = Zlib::GzipWriter.new(output)
    zipped.write(string)
    zipped.close
    output.string
  end
end