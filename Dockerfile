# Multi-stage build for Crystal REST API
FROM crystallang/crystal:1.13-alpine AS builder
WORKDIR /app
COPY src/rest_api.cr .
RUN crystal build rest_api.cr -o rest-api --release --static

# Runtime minimal container
FROM alpine:3.19
RUN apk add --no-cache libstdc++ libgcc ca-certificates

# Non-root user setup
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app

COPY --from=builder /app/rest-api .
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:${PORT:-8080}/ || exit 1

CMD ["./rest-api"]
