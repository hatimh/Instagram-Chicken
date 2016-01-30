# Homepage (Root path)
require "instagram"

enable :sessions

CALLBACK_URL = "http://localhost:3000/oauth/callback"

Instagram.configure do |config|
  config.client_id = "4a9c8bcaff1b4b03901e20bb5777d8bd"
  config.client_secret = "1b574823e66d41dbbbb2a84b18646ddd"
end

helpers do
  def image_tag(media_item)
    "<img src='#{media_item.images.thumbnail.url}' alt='Promo Image')"
  end
end

# get methods #
get '/' do
  @client = Instagram.client(:access_token => session[:access_token])
  erb :'/index'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:scope => "public_content", :redirect_uri => CALLBACK_URL)
end

get "/oauth/disconnect" do
  session[:access_token] = nil
  redirect "/"
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/"
end
