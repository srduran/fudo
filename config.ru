require 'pry'
require 'rack'
require 'json'
require 'jwt'
require 'dotenv/load'
require 'time'
require_relative 'app/main_app'
require_relative 'app/auth'
require_relative 'app/product_store'
require_relative 'app/async_worker'

run MainApp.new