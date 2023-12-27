# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Pre-requisites for Development

### Running Redis

```
# create a docker volume
docker volume create bomngrams

# run the redis server
docker run -p 6379:6379 --name bomngrams-redis -d -v bomngrams:/data redis redis-server --appendonly yes
```

### Seeding the Redis cache

Get a rails console

```
rails c
```

Create an importer and run the importer

```
importer = Ngram::Importer.new
importer.run
```