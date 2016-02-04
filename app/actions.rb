# Homepage (Root path)
require "instagram"

enable :sessions

CALLBACK_URL = "http://localhost:3000/oauth/callback"

Instagram.configure do |config|
  config.client_id = "7b2f272779ce4767a882aa3aef445645"
  config.client_secret = "a8af048a841a4da59cb3ebc7742ce0d1"
  config.scope = "public_content likes"
end

helpers do
  def image_tag(media_item)
    "<img src='#{media_item.images.thumbnail.url}' alt='Promo Image')"
  end
end

# get methods #
get '/' do
  # @client = Instagram.client(:access_token => session[:access_token])
  if session[:access_token] == nil
    erb :'/login'
  else 
    erb :index
  end 
end

# Login page
get '/login' do
  if session[:access_token] == nil 
    erb :'login'
  else
    erb :'user'
  end
end

# Category page
get '/category/:n' do
  @category = params[:n]
  if session[:access_token] == nil 
    erb :'login'
  else
    erb :'category'
  end  
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/disconnect" do
  session[:access_token] = nil
  redirect "/login"
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/"
end

get "/beatit" do
  session[:beatit] = true
  redirect "/user" 
end

get "/user" do
  if session[:access_token] == nil 
    erb :'login'
  else
    erb :'user'
  end  
end


post '/search' do
  client = Instagram.client(:access_token => session[:access_token])
  @goto = params[:category]
  redirect "/category/#{@goto}"
end

post '/category/:hash/media_like/:id' do
  client = Instagram.client(:access_token => session[:access_token])
  client.like_media("#{params[:id]}")
  @hash = params[:hash]
  redirect "/category/#{@hash}"
end

post '/category/:hash/media_unlike/:id' do
  client = Instagram.client(:access_token => session[:access_token])
  client.unlike_media("#{params[:id]}")
  @hash = params[:hash]
  redirect "/category/#{@hash}"
end


# # Homepage (Root path)

# require "sinatra"
# require "instagram"

# enable :sessions

# CALLBACK_URL = "http://localhost:3000/oauth/callback"

# Instagram.configure do |config|
#  # config.client_id = "7b2f272779ce4767a882aa3aef445645"
#  # config.client_secret = "31c5963931964e5d9abc7e8abe4cce93"
#  config.client_id = "4a9c8bcaff1b4b03901e20bb5777d8bd"
#  config.client_secret = "1b574823e66d41dbbbb2a84b18646ddd"
#  config.scope = "public_content likes"
#   # For secured endpoints only
#   #config.client_ips = '<Comma separated list of IPs>'
# end

# get "/beatit" do
#   session[:beatit] = true
#   redirect "/user" 
# end

# get "/" do
#   if session[:access_token] == nil 
#     erb :'login'
#   else
#     erb :'index'
#   end  
# end

# get "/category/:n" do
#   @category = params[:n]
#   erb :'category'
# end

# get "/user" do
#   if session[:access_token] == nil 
#     erb :'login'
#   else
#     erb :'user'
#   end  
# end

# get "/oauth/connect" do
#   redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
# end

# get '/oauth/disconnect' do
#   session[:access_token] = nil
#   erb :'login'
# end

# get "/oauth/callback" do
#   response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
#   session[:access_token] = response.access_token
#   #session[:access_token] = "16384709.6ac06b4.49b97800d7fd4ac799a2c889f50f2587"
#   create_user(Instagram.client(:access_token => session[:access_token]).user)
#   erb :'index'
# end

# get "/nav" do
#   html =
#   """
#     <h1>Ruby Instagram Gem Sample Application</h1>
#     <ol>
#       <li><a href='/user_recent_media'>User Recent Media</a> Calls user_recent_media - Get a list of a user's most recent media</li>
#       <li><a href='/user_media_feed'>User Media Feed</a> Calls user_media_feed - Get the currently authenticated user's media feed uses pagination</li>
#       <li><a href='/location_recent_media'>Location Recent Media</a> Calls location_recent_media - Get a list of recent media at a given location, in this case, the Instagram office</li>
#       <li><a href='/media_search'>Media Search</a> Calls media_search - Get a list of media close to a given latitude and longitude</li>
#       <li><a href='/media_popular'>Popular Media</a> Calls media_popular - Get a list of the overall most popular media items</li>
#       <li><a href='/user_search'>User Search</a> Calls user_search - Search for users on instagram, by name or username</li>
#       <li><a href='/location_search'>Location Search</a> Calls location_search - Search for a location by lat/lng</li>
#       <li><a href='/location_search_4square'>Location Search - 4Square</a> Calls location_search - Search for a location by Fousquare ID (v2)</li>
#       <li><a href='/tags'>Tags</a>Search for tags, view tag info and get media by tag</li>
#       <li><a href='/limits'>View Rate Limit and Remaining API calls</a>View remaining and ratelimit info.</li>
#     </ol>
#   """
#   html
# end

# get "/user_recent_media" do
#   client = Instagram.client(:access_token => session[:access_token])
#   user = client.user

#   html = "<h1>#{user.username}'s recent media</h1>"
#   html << "<h1>#{user.bio} bio</h1>"
#   for media_item in client.user_recent_media
#     html << "<div style='float:left;'><img src='#{media_item.images.thumbnail.url}'><br/> <a href='/media_like/media_item.id'>Like</a>  <a href='/media_unlike/media_item.id'>Un-Like</a>  <br/>LikesCount=#{media_item.likes[:count]}</div>"
#   end
#   html
# end



# get "/user_media_feed" do
#   client = Instagram.client(:access_token => session[:access_token])
#   user = client.user
#   html = "<h1>#{user.username}'s media feed</h1>"

#   page_1 = client.user_media_feed(777)
#   page_2_max_id = page_1.pagination.next_max_id
#   page_2 = client.user_recent_media(777, :max_id => page_2_max_id ) unless page_2_max_id.nil?
#   html << "<h2>Page 1</h2><br/>"
#   for media_item in page_1
#     html << "<img src='#{media_item.images.thumbnail.url}'>"
#   end
#   html << "<h2>Page 2</h2><br/>"
#   for media_item in page_2
#     html << "<img src='#{media_item.images.thumbnail.url}'>"
#   end
#   html
# end

# get "/location_recent_media" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Media from the Instagram Office</h1>"
#   for media_item in client.location_recent_media(514276)
#     html << "<img src='#{media_item.images.thumbnail.url}'>"
#   end
#   html
# end

# get "/media_search" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Get a list of media close to a given latitude and longitude</h1>"
#   for media_item in client.media_search("51.0486","114")
#     html << "<img src='#{media_item.images.thumbnail.url}'>"
#   end
#   html
# end

# get "/media_popular" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Get a list of the overall most popular media items</h1>"
#   for media_item in client.media_popular
#     html << "<img src='#{media_item.images.thumbnail.url}'>"
#   end
#   html
# end

# get "/user_search" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Search for users on instagram, by name or usernames</h1>"
#   for user in client.user_search("instagram")
#     html << "<li> <img src='#{user.profile_picture}'> #{user.username} #{user.full_name}</li>"
#   end
#   html
# end

# get "/location_search" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Search for a location by lat/lng with a radius of 5000m</h1>"
#   for location in client.location_search("48.858844","2.294351","5000")
#     html << "<li> #{location.name} <a href='https://www.google.com/maps/preview/@#{location.latitude},#{location.longitude},19z'>Map</a></li>"
#   end
#   html
# end

# get "/location_search_4square" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Search for a location by Fousquare ID (v2)</h1>"
#   for location in client.location_search("3fd66200f964a520c5f11ee3")
#     html << "<li> #{location.name} <a href='https://www.google.com/maps/preview/@#{location.latitude},#{location.longitude},19z'>Map</a></li>"
#   end
#   html
# end

# get "/tags" do

#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Search for tags, get tag info and get media by tag</h1>"
#   tags = client.tag_search('beatdhtshiz')
#   category = []
#   tags.each do |tag|
#     category << tag.name.slice(12, tag.name.length)
#   end 

#   puts category.inspect

#   html << "<h2>Tag Name = #{tags[0].name}. Media Count =  #{tags[0].media_count}. </h2><br/><br/>"
  
#   for media_item in client.tag_recent_media(tags[0].name)
#     html << "<img src='#{media_item.images.thumbnail.url}'>"
#   end
#   len = client.tag_search(tags[0].name).length
#   html << "#{len}"
#   html
# end

# get "/limits" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1/>View API Rate Limit and calls remaining</h1>"
#   response = client.utils_raw_response
#   html << "Rate Limit = #{response.headers[:x_ratelimit_limit]}.  <br/>Calls Remaining = #{response.headers[:x_ratelimit_remaining]}"

#   html
# end

# helpers do
#   def create_user(user)
#     data_user = User.find_by(instagram_user_id: user.id.to_i)
#     unless user
#       data_user = User.create(username: user.username , full_name: user.full_name , instagram_user_id: user.id.to_i, 
#                   profile_picture: user.profile_picture , bio: user.bio, website: user.website)
#     end 
#     data_user
#   end

# end
