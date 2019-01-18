#!/bin/env sh

# Basic functions to configure kong with a custom API

api_container_name="api-container"
api_port=9000

function create_user_service() {
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=api-service' \
  --data "url=http://$api_container_name:$api_port/api/v1/login"
}

function create_user_route() {
curl -i -X POST \
  --url http://localhost:8001/services/api-service/routes \
	--header 'Content-Type: application/json' \
  --data '{"paths":["/login"]}'
}

function login_user() {
curl -i -X POST 'localhost:8000/login' \
	--header 'Content-Type: application/json' \
	--data '{"username":"my-name","password":"my-secret"}'
}

function get_services() {
curl -X GET --url http://localhost:8001/services/ | python -m json.tool
}

function get_routes() {
curl -X GET --url http://localhost:8001/routes/ | python -m json.tool
}

function delete_route() {
curl -i -X DELETE --url http://localhost:8001/routes/$1
}

function delete_service() {
curl -i -X DELETE --url http://localhost:8001/services/$1
}

