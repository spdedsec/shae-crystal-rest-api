# Crystal REST API

A high-performance RESTful API written in Crystal and deployed on Vercel Fluid compute containers, featuring an embedded Apple Human Interface Guidelines (HIG) API Explorer.

## Features

- **Apple HIG API Explorer** — Interactive browser UI with light/dark mode and SF Pro typography
- **Container Architecture** — Multi-stage OCI container built on Alpine Linux with non-root user execution
- **REST Endpoints** — In-memory CRUD operations with UUID generation
- **CORS Support** — Full CORS headers for web and mobile frontends
- **Health Checks** — Native healthcheck probe on `/` and `/health`
- **Dynamic Port Binding** — Binds to `$PORT` environment variable with fallback to 8080

## Endpoints

| Method | Route | Description | Response |
|--------|-------|-------------|----------|
| `GET` | `/` | Apple HIG Web UI (Browser) / Service Status (JSON) | HTML / 200 JSON |
| `GET` | `/health` | Healthcheck probe | 200 JSON |
| `GET` | `/items` | List all items | 200 JSON |
| `POST` | `/items` | Create new item (`{"data":"..."}`) | 201 JSON |
| `GET` | `/items/{id}` | Get item by ID | 200 / 404 JSON |
| `DELETE` | `/items/{id}` | Delete item by ID | 200 / 404 JSON |

## Local Development (Docker)

```bash
docker build -t crystal-rest-api .
docker run -p 8080:8080 crystal-rest-api
```

Visit `http://localhost:8080`.

## Deployment

Configured for Vercel with `"framework": "container"` and multi-stage Docker build.

## License

MIT © 2026 spdedsec
