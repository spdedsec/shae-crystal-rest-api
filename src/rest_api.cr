require "http/server"
require "json"
require "uuid"

items = {} of String => Hash(String, String)
items["1"] = {"data" => "Apple HIG System Integration"}
items["2"] = {"data" => "Crystal High-Performance REST API"}

HTML_UI = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="light dark">
  <meta name="description" content="Crystal REST API - Apple HIG Explorer">
  <title>Crystal REST API &mdash; Apple HIG Studio</title>
  <style>
    :root {
      color-scheme: light dark;
      --system-blue: #007AFF;
      --system-blue-hover: #0062CC;
      --system-green: #34C759;
      --system-red: #FF3B30;
      --system-bg: #FFFFFF;
      --system-secondary-bg: #F2F2F7;
      --system-card-bg: rgba(255, 255, 255, 0.88);
      --system-label: #000000;
      --system-secondary-label: rgba(60, 60, 67, 0.60);
      --system-border: rgba(0, 0, 0, 0.10);
      --system-fill: rgba(120, 120, 128, 0.16);
      --system-chrome: rgba(255, 255, 255, 0.82);
      --font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", "SF Pro", system-ui, sans-serif;
      --font-mono: -apple-system-ui-monospaced, "SF Mono", Menlo, Monaco, Consolas, monospace;
      --radius-sm: 8px;
      --radius-md: 12px;
      --radius-lg: 16px;
      --radius-pill: 9999px;
      --shadow-2: 0 4px 6px -1px rgba(0, 0, 0, 0.07), 0 2px 4px -1px rgba(0, 0, 0, 0.04);
      --spring: cubic-bezier(0.4, 0, 0.2, 1);
    }
    @media (prefers-color-scheme: dark) {
      :root {
        --system-blue: #0A84FF;
        --system-blue-hover: #409CFF;
        --system-green: #30D158;
        --system-red: #FF453A;
        --system-bg: #000000;
        --system-secondary-bg: #1C1C1E;
        --system-card-bg: rgba(28, 28, 30, 0.88);
        --system-label: #FFFFFF;
        --system-secondary-label: rgba(235, 235, 245, 0.60);
        --system-border: rgba(255, 255, 255, 0.14);
        --system-fill: rgba(120, 120, 128, 0.36);
        --system-chrome: rgba(28, 28, 30, 0.82);
      }
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: var(--font-family);
      background-color: var(--system-secondary-bg);
      color: var(--system-label);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      -webkit-font-smoothing: antialiased;
    }
    .header {
      height: 56px;
      background: var(--system-chrome);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border-bottom: 1px solid var(--system-border);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 24px;
      position: sticky;
      top: 0;
    }
    .brand { display: flex; align-items: center; gap: 8px; }
    .badge {
      font-size: 11px;
      font-weight: 700;
      padding: 2px 8px;
      background: var(--system-blue);
      color: #fff;
      border-radius: var(--radius-pill);
    }
    .title { font-size: 17px; font-weight: 600; }
    .status-badge {
      font-size: 12px;
      font-weight: 600;
      color: var(--system-green);
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .dot { width: 8px; height: 8px; border-radius: 50%; background: var(--system-green); }
    .container {
      max-width: 1000px;
      margin: 0 auto;
      width: 100%;
      padding: 32px 24px;
      display: flex;
      flex-direction: column;
      gap: 24px;
      flex: 1;
    }
    .card {
      background: var(--system-card-bg);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border-radius: var(--radius-lg);
      border: 1px solid var(--system-border);
      box-shadow: var(--shadow-2);
      padding: 24px;
    }
    .card-title {
      font-size: 14px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.04em;
      color: var(--system-secondary-label);
      margin-bottom: 16px;
    }
    .endpoint-grid { display: flex; flex-direction: column; gap: 12px; }
    .endpoint-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 16px;
      background: var(--system-fill);
      border-radius: var(--radius-md);
      gap: 16px;
    }
    .method-tag {
      font-family: var(--font-mono);
      font-size: 12px;
      font-weight: 700;
      padding: 4px 8px;
      border-radius: var(--radius-sm);
      min-width: 54px;
      text-align: center;
    }
    .get { background: rgba(52, 199, 89, 0.2); color: var(--system-green); }
    .post { background: rgba(0, 122, 255, 0.2); color: var(--system-blue); }
    .delete { background: rgba(255, 59, 48, 0.2); color: var(--system-red); }
    .path { font-family: var(--font-mono); font-size: 14px; flex: 1; }
    .desc { font-size: 13px; color: var(--system-secondary-label); }
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-height: 44px;
      min-width: 44px;
      padding: 0 16px;
      font-family: var(--font-family);
      font-size: 13px;
      font-weight: 500;
      border-radius: var(--radius-pill);
      border: none;
      cursor: pointer;
      background: var(--system-blue);
      color: #fff;
      transition: all 150ms var(--spring);
    }
    .btn:hover { background: var(--system-blue-hover); transform: scale(0.98); }
    .btn:focus-visible { outline: 2px solid var(--system-blue); outline-offset: 2px; }
    .response-area {
      margin-top: 16px;
      background: var(--system-bg);
      border: 1px solid var(--system-border);
      border-radius: var(--radius-md);
      padding: 16px;
      font-family: var(--font-mono);
      font-size: 13px;
      max-height: 240px;
      overflow-y: auto;
      white-space: pre-wrap;
      word-break: break-all;
    }
    .footer {
      height: 48px;
      padding: 0 24px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 12px;
      color: var(--system-secondary-label);
      border-top: 1px solid var(--system-border);
    }
    @media (prefers-reduced-motion: reduce) {
      *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
    }
  </style>
</head>
<body>
  <header class="header">
    <div class="brand">
      <span class="badge">CRYSTAL</span>
      <h1 class="title">REST API</h1>
    </div>
    <div class="status-badge">
      <span class="dot"></span>
      <span>200 OK &middot; Container Runtime</span>
    </div>
  </header>

  <main class="container">
    <section class="card">
      <h2 class="card-title">REST Endpoints (Apple HIG Explorer)</h2>
      <div class="endpoint-grid">
        <div class="endpoint-row">
          <span class="method-tag get">GET</span>
          <span class="path">/items</span>
          <span class="desc">Retrieve item collection</span>
          <button class="btn" onclick="runReq('GET', '/items')">Test</button>
        </div>
        <div class="endpoint-row">
          <span class="method-tag post">POST</span>
          <span class="path">/items</span>
          <span class="desc">Store new item payload</span>
          <button class="btn" onclick="runReq('POST', '/items', {data: 'Payload from Apple HIG Explorer'})">Create</button>
        </div>
        <div class="endpoint-row">
          <span class="method-tag get">GET</span>
          <span class="path">/health</span>
          <span class="desc">Container healthcheck</span>
          <button class="btn" onclick="runReq('GET', '/health')">Test</button>
        </div>
      </div>
      <div class="response-area" id="respOutput">// Click "Test" on any endpoint above to execute live request</div>
    </section>
  </main>

  <footer class="footer">
    <div>Apple Human Interface Guidelines &middot; Crystal Container Runtime</div>
    <div><a href="https://github.com/spdedsec/shae-crystal-rest-api" target="_blank" rel="noopener" style="color:var(--system-blue); text-decoration:none;">GitHub</a></div>
  </footer>

  <script>
    async function runReq(method, path, body) {
      const out = document.getElementById('respOutput');
      out.textContent = 'Executing ' + method + ' ' + path + '...';
      try {
        const opts = { method, headers: { 'Accept': 'application/json' } };
        if (body) {
          opts.headers['Content-Type'] = 'application/json';
          opts.body = JSON.stringify(body);
        }
        const res = await fetch(path, opts);
        const data = await res.json();
        out.textContent = 'Status: ' + res.status + ' ' + res.statusText + '\n\n' + JSON.stringify(data, null, 2);
      } catch (err) {
        out.textContent = 'Error: ' + err.message;
      }
    }
  </script>
</body>
</html>
HTML

port = ENV["PORT"]?.try(&.to_i?) || 8080

server = HTTP::Server.new do |context|
  req = context.request
  path = req.path
  method = req.method

  # Set CORS headers
  context.response.headers["Access-Control-Allow-Origin"] = "*"
  context.response.headers["Access-Control-Allow-Methods"] = "GET, POST, DELETE, OPTIONS"
  context.response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, Accept"

  if method == "OPTIONS"
    context.response.status = HTTP::Status::OK
    next
  end

  # Health check & root route
  if (path == "/" || path == "/health") && (method == "GET" || method == "HEAD")
    accept = req.headers["Accept"]? || ""
    if path == "/" && accept.includes?("text/html")
      context.response.content_type = "text/html; charset=utf-8"
      context.response.status = HTTP::Status::OK
      context.response.print HTML_UI unless method == "HEAD"
    else
      context.response.content_type = "application/json"
      context.response.status = HTTP::Status::OK
      unless method == "HEAD"
        context.response.print({
          "status" => "ok",
          "service" => "shae-crystal-rest-api",
          "version" => "1.0.0",
          "design" => "Apple HIG"
        }.to_json)
      end
    end
  elsif (method == "GET" || method == "HEAD") && path == "/items"
    context.response.content_type = "application/json"
    result = items.keys.map do |k|
      {"id" => k, "data" => items[k]["data"]}
    end
    context.response.status = HTTP::Status::OK
    context.response.print result.to_json unless method == "HEAD"
  elsif method == "POST" && path == "/items"
    context.response.content_type = "application/json"
    body = req.body.try(&.gets_to_end) || "{}"
    begin
      data = JSON.parse(body)
      id = data["id"]?.try(&.as_s?) || UUID.random.to_s
      data_str = data["data"]?.try(&.as_s?) || ""
      items[id] = {"data" => data_str}
      context.response.status = HTTP::Status::CREATED
      context.response.print({"id" => id, "status" => "created"}.to_json)
    rescue ex
      context.response.status = HTTP::Status::BAD_REQUEST
      context.response.print({"error" => "invalid json", "details" => ex.message}.to_json)
    end
  elsif method == "GET" && path.starts_with?("/items/")
    context.response.content_type = "application/json"
    id = path.split("/").last
    if items.has_key?(id)
      context.response.status = HTTP::Status::OK
      context.response.print({"id" => id, "data" => items[id]["data"]}.to_json)
    else
      context.response.status = HTTP::Status::NOT_FOUND
      context.response.print({"error" => "item not found"}.to_json)
    end
  elsif method == "DELETE" && path.starts_with?("/items/")
    context.response.content_type = "application/json"
    id = path.split("/").last
    if items.delete(id)
      context.response.status = HTTP::Status::OK
      context.response.print({"status" => "deleted", "id" => id}.to_json)
    else
      context.response.status = HTTP::Status::NOT_FOUND
      context.response.print({"error" => "item not found"}.to_json)
    end
  else
    context.response.content_type = "application/json"
    context.response.status = HTTP::Status::NOT_FOUND
    context.response.print({"error" => "route not found", "path" => path}.to_json)
  end
end

puts "Crystal REST API listening on http://0.0.0.0:#{port}"
server.bind_tcp("0.0.0.0", port)
server.listen
