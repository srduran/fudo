class GzipMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    encoding = headers['Accept-Encoding']
    type = headers['Content-Type']

    if encoding.include?('gzip') && type.include?('application/json')
      compressed = gzip(body)
      headers['Content-Encoding'] = 'gzip'
      headers['Content-Length'] = compressed.bytesize.to_s
      headers['X-Compressed'] = 'true'
      body = [compressed]
    end
    
    [status, headers, body]
  end

  private
  def gzip(body)
    output = StringIO.new
    zipped = Zlib::GzipWriter.new(output)
    body.each { |part| zipped.write(part) }
    zipped.close
    output.string
  end
end