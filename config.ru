require 'pry'
require 'pry-byebug'
require 'rack'
require 'json'
require 'jwt'
require 'dotenv/load'
require 'time'
require 'zlib'
require_relative 'app/main_app'
require_relative 'app/auth'
require_relative 'app/product_store'
require_relative 'app/async_worker'
require_relative 'app/gzip_middleware'

use GzipMiddleware
run MainApp.new