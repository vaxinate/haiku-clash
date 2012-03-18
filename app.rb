require 'sinatra'
require 'haml'

require_relative 'lib/haiku'

Mongoid.load!("config/mongoid.yml")

# Mongoid.configure do |config|
#   config.master = Mongo::Connection.new.db("haikuduel")
# end

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
  Haiku.find(params[:win]).update_record!(:win).save
  Haiku.find(params[:loss]).update_record!(:loss).save
  redirect to '/battle'
end

get '/leaderboard' do
  @haikus = Haiku.all.sort_by { |haiku| -haiku.record['win'] }
  haml :leaderboard
end
