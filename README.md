# Rehoming [![Code Climate](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/badges/0e1bd5d086d10177b230/gpa.svg)](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/feed) [![Test Coverage](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/badges/0e1bd5d086d10177b230/coverage.svg)](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/coverage) [![Issue Count](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/badges/0e1bd5d086d10177b230/issue_count.svg)](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/feed)

入伙 API 端

## System dependencies

* Ruby 2.4.1
* Rails ~> 5.1.0
* Redis 3.2.9
* Memcached 1.4.36
* MySQL 5.7.18

## Configuration

```
cp config/database.yml.example config/database.yml
cp config/application.yml.example config/application.yml
cp config/secrets.yml.example config/secrets.yml
```

## Database creation and initialization

```
rake dev:rebuild
```

## How to run the test suite

```
bin/rails db:migrate RAILS_ENV=test
rake
```

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

### Gems you should know

* [active_type](https://github.com/makandra/active_type)
* [active_model_serializers](https://github.com/rails-api/active_model_serializers)
* [acts_as_paranoid](https://github.com/ActsAsParanoid/acts_as_paranoid)
* [redis-rb](https://github.com/redis/redis-rb)
* [redis-objects](https://github.com/nateware/redis-objects)
