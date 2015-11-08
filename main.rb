require 'hue'
require 'faraday'
require 'json'
require 'pp'

WEATHER_URL = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"

#client = Hue::Client.new
#
#connection = Faraday.new(:url => WEATHER_URL ) do |faraday|
#	faraday.request :url_encoded
#	faraday.response :logger 
#  faraday.adapter Faraday.default_adapter
#end
#
#response = connection.get

res = Faraday.get WEATHER_URL
json_body = JSON.load(res.body)
today_telop = json_body["forecasts"].first["telop"]
pp today_telop
