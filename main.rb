require 'hue'
require 'faraday'
require 'json'
require 'pp'


def rgbtohsv red,green,blue
	max_num = [red,green,blue].max
	min_num = [red,green,blue].min
	sat = 255 * ((max_num - min_num) / max_num)
	hue = 0
	if max_num == red
		hue = 60 *((blue-green)/ (max_num - min_num))
	elsif max_num == green
		hue = 60 *((red-blue)/ (max_num - min_num))
	elsif max_num == blue
		hue = 60 *((green-red)/ (max_num - min_num))
	else
	end

	if hue < 0
		hue += 380 
	end

	return {hue: hue, sat: sat, brightness: max_num }
end

#WEATHER_URL = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"
WEATHER_URL = "http://www.drk7.jp/weather/json/13.js"

client = Hue::Client.new

res = Faraday.get WEATHER_URL
# JSONP parse
res.body.gsub!(/^\w+\.callback\(/i,"")
res.body.gsub!(/\);/,"")
json_body = JSON.load(res.body)
rainparsent =  json_body["pref"]["area"]["東京地方"]["info"].first["rainfallchance"]["period"]
parsent = 0
# 12-18時台
parsent = rainparsent[2]["content"]
# 平均をとる
#rainparsent.each do |e|
#	parsent += e["content"].to_i
#end
#parsent /= 4
STDERR.puts parsent

object_light = Object.new

client.lights.each do |light|
	if light.name =~ /floor/
		object_light = light
	end
end

orange_state = {on: true, saturation: 255, brightness: 210, hue: 0}
blue_state = {on: true, saturation: 255, brightness: 210, hue:65535 / 12 * 8}
if parsent.to_i > 50
	object_light.set_state(blue_state,1)
else
	object_light.set_state(orange_state,1)
end

