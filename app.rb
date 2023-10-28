require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  currency_str = HTTP.get("https://api.exchangerate.host/live?access_key=fa37e94f30043729bbef4e8a0bb21d65")
  currency_hash = JSON.parse(currency_str)["quotes"]

  @currancy_array = []
  currancy_one = "USD"

  currency_hash.each do |key, value|
    temp = key.gsub(currancy_one, "")
    @currancy_array.push([temp,"/#{temp}"])
  end

  erb(:homepage)
end

get("/:currency_one") do
  @currancy_one= params.fetch("currency_one").to_s

  currency_str = HTTP.get("https://api.exchangerate.host/live?access_key=fa37e94f30043729bbef4e8a0bb21d65&source=" + @currancy_one)
  currency_hash = JSON.parse(currency_str)["quotes"]
  @currancy_array = [[@currancy_one,"/#{@currancy_one}/#{@currancy_one}"]]

  currency_hash.each do |key, value|
    temp = key.gsub(@currancy_one, "")
    @currancy_array.push([temp,"/#{@currancy_one}/#{temp}"])
  end

  erb(:route_one)
end

get("/:currency_one/:currency_two") do
  @one= params.fetch("currency_one").to_s
  @two = params.fetch("currency_two").to_s
  @return_route = "/#{@one}"

  currency_str = HTTP.get("https://api.exchangerate.host/convert?access_key=fa37e94f30043729bbef4e8a0bb21d65&from=#{@one}&to=#{@two}&amount=1")
  @currency_conversion = JSON.parse(currency_str)["result"]

  erb(:flexible)
end
