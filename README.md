# Rpc

Consumes given webservice with a list of images, resizes each image into three different sizes, uploads them to S3 and provides a list with the urls at `api/images`.

## Why Elixir/Phoenix?

Phoenix is my web framework of choice mostly due to Elixir, but also due to it's structure(I really like the new 1.3rc context structure), I guess the only thing that could be weighed against it is package maturity, but the community is alive and moving fast and although you can't always find pretty docs the `h` IEx helper is great and Elixir code is usually readable enough.

## Installation

What you need installed:
- [Elixir](https://elixir-lang.org/install.html) 1.4.2 or later
- [ImageMagick](http://www.imagemagick.org/script/index.php)
- [MongoDB](https://www.mongodb.com/) version 3.4.4

Then clone the repo, enter the directory and get the dependencies:
```bash
$ git clone https://github.com/erikdsi/rpc
$ cd rpc
$ mix deps.get
```

## Configuration

Config files are at `/config`

### MongoDB

You can find Mongos's config under `:rpc, :db`.

You can configure database names for dev and test environment at `config/dev.exs` and `config/test.exs`

If Mongo is running on localhost no extra configuration is needed.

If additional configuration is needed you have to add it to `config/config.exs`, most likely to be needed are:
```elixir
  :hostname - Server hostname
  :port - Server port
  :username - Username
  :password - User password
  :auth - Additionally users to authenticate (list of keyword lists with
    the keys :username and :password)
  :auth_source - Database to authenticate against
```

### AWS

On `config/config.exs` you need to configure the AWS credentials and the region of your bucket:
```elixir
config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role],
  region: "sa-east-1"
```
Here it's getting credentials from environment variables.

You have to create a bucket and change `:rpc, :bucket` at `config/config.ex` accordingly.
```elixir
config :rpc,
  bucket: "your-bucket",
```
You can also disable aws at `config/config.ex` setting `:use_aws` to `false` and it'll generate links to localhost instead.

## Usage

In the project directory use `mix test` to run tests.
To launch a local webserver use `mix phx.server`
```bash
$ mix test
$ mix phx.server
```

The images will be generated at server startup if they're not in the db.
With default config you can access the generated list of urls at `GET http://localhost:4000/api/images`