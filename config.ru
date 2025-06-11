require 'pry'
require 'rack'
require 'json'
require 'jwt'
require 'dotenv/load'
require_relative 'app/main_app'
require_relative 'app/auth'
require_relative 'app/product_store'

run MainApp.new