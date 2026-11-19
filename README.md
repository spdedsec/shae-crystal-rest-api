# SHAE Crystal REST API

A minimal REST API written in Crystal.

## Features
- GET /items — list items
- POST /items — create item (JSON body)
- GET /items/:id — get item
- DELETE /items/:id — delete item
- JSON responses, in-memory storage

## Install
```bash
./scripts/install.sh
# Or manually:
crystal build src/rest_api.cr -o shae-rest-api --release
cp shae-rest-api ~/.local/bin/
```

## Usage
```bash
shae-rest-api
# API listens on http://0.0.0.0:8080
```

## Design
Follows SHAE Field Manual: warm paper #F2EEE5, ink #191712, oxide #B3341B, 0px radius, 1px borders.
