require 'hue'
require 'faraday'

WEATHER_URL = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"

client = Hue::Client.new

connection = Faraday.new(:url => WEATHER_URL ) do |faraday|
	faraday.request :url_encoded
	faraday.response :logger 
  faraday.adapter Faraday.default_adapter
end

