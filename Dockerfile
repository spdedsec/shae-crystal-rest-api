FROM crystallang/crystal:1.13-alpine AS builder
WORKDIR /app
COPY src/rest_api.cr .
RUN crystal build rest_api.cr -o rest-api --release --static

FROM alpine:3.19
RUN apk add --no-cache libstdc++ libgcc
WORKDIR /app
COPY --from=builder /app/rest-api .
EXPOSE 8080
CMD ["./rest-api"]
