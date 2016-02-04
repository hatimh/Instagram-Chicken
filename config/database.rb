configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  set :database, {

    adapter: "postgresql",
    host: "ec2-54-83-0-187.compute-1.amazonaws.com",
    username: "hdadxjxzctdlbz",
    password: "gPEnq-VKQg66m8_glx3cdjSarJ",
    database: "d20pilaqpgmg7o"
  }

  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end
