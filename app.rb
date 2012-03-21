require 'sinatra'
require 'haml'
require 'rack/csrf'

require_relative 'lib/haiku'

Mongoid.load!("config/mongoid.yml")

# Mongoid.configure do |config|
#   config.master = Mongo::Connection.new.db("haikuduel")
# end

configure do
  csrf_token = ENV['RACK_ENV'] == "production" ? ENV['CSRF_SECRET'] : "herpderp"

  use Rack::Session::Cookie, :secret => csrf_token
  use Rack::Csrf, :raise => true
end

helpers do
  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end
end

get '/' do
  redirect to '/battle'
end

get '/haiku' do
  @haiku = Haiku.new :lines => []
  puts @haiku.lines.map(&:class)
  haml :form
end

post '/haiku' do
  @haiku = Haiku.new :lines => params[:haiku].split("\n").map(&:chomp)
  if @haiku.save
    redirect to "/haiku/#{@haiku.id}"
  else
    haml :form
  end
end

get '/haiku/:id' do
  @haiku = Haiku.find(params[:id])
  haml :haiku_show
end

get '/battle' do
  @haikus = Haiku.all.shuffle
  haml :battle
end

post '/battle' do
  winner = Haiku.find(params[:win])
  loser = Haiku.find(params[:loss])

  winner.votes << Vote.new(:type => :win)
  loser.votes << Vote.new(:type => :loss)

  winner.save
  loser.save

  redirect to '/battle'
end

get '/leaderboard' do
  @haikus = Haiku.all.sort_by { |haiku| haiku.wins.length }
  haml :leaderboard
end
