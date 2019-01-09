# DiscoveryApi

Discovery API serves as middleware between Kylo and our Data Discovery UI.

### To start your Phoenix server(from the root directory):

  * First, `export DATA_LAKE_URL=https://kylo.dev.internal.smartcolumbusos.com`
    * You will need to be on the vpn if you use the dev kylo as your backing datalake
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `iex -S mix phx.server`

### To run inside a container(from the root directory):
  * `docker build . -t <image_name:tag>`
  * `docker run -d -e DATA_LAKE_URL=https://mockylo.dev.internal.smartcolumbusos.com -p 4000:80 <image_name:tag>`
    * You will need to be on the vpn if you use the dev mockylo as your backing datalake

### To see the applicaiton live:
  * Go to localhost:4000/metrics
  * Go to http://localhost:4000/v1/api/dataset/search
  * You can get paginated results using the url http://localhost:4000/v1/api/dataset/search?offset=10&limit=5&sort=name_asc

### Deploying to Sandbox

* This application can be deployed to the sandbox environment using the following Terraform commands:
  * `tf init`
  * `tf workspace new {NEW_WORKSPACE_NAME}`
  * `tf plan --var=file=variables/sandbox.tfvars --out=out.out`
  * `tf apply out.out`
