require "http/server"
require "json"

items = {} of String => HashMap(String, String).new

server = HTTP::Server.new do |context|
  req = context.request
  path = req.path.url_decode
  method = req.method

  content_type "application/json"

  if method == "GET" && path == "/items"
    result = items.keys.map do |k|
      {"id" => k, "data" => items[k]}
    end
    context.response.print JSON.generate(result)
  elsif method == "POST" && path == "/items"
    body = req.body.gets_to_end
    data = JSON.parse(body)
    id = data["id"]?.as_s || UUID.random.to_s
    items[id] = {"data" => data["data"]?.as_s || ""}
    context.response.status = 201
    context.response.print JSON.generate({"id" => id, "status" => "created"})
  elsif method == "GET" && path.match?(%r{^/items/})
    id = path.split("/").last
    if items.has_key?(id)
      context.response.print JSON.generate({"id" => id, "data" => items[id]})
    else
      context.response.status = 404
      context.response.print JSON.generate({"error" => "not found"})
    end
  elsif method == "DELETE" && path.match?(%r{^/items/})
    id = path.split("/").last
    if items.delete(id)
      context.response.print JSON.generate({"status" => "deleted"})
    else
      context.response.status = 404
      context.response.print JSON.generate({"error" => "not found"})
    end
  else
    context.response.status = 404
    context.response.print JSON.generate({"error" => "route not found"})
  end
end

puts "SHAE Crystal REST API listening on http://0.0.0.0:8080"
server.listen("0.0.0.0", 8080)
