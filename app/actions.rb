# Homepage (Root path)
require "instagram"

enable :sessions

CALLBACK_URL = "http://localhost:3000/oauth/callback"

Instagram.configure do |config|
  config.client_id = "4a9c8bcaff1b4b03901e20bb5777d8bd"
  config.client_secret = "1b574823e66d41dbbbb2a84b18646ddd"
end

# get methods #
get '/' do
  erb :'/index'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end
