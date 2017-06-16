# Rehoming [![Code Climate](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/badges/0e1bd5d086d10177b230/gpa.svg)](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/feed) [![Test Coverage](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/badges/0e1bd5d086d10177b230/coverage.svg)](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/coverage) [![Issue Count](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/badges/0e1bd5d086d10177b230/issue_count.svg)](https://codeclimate.com/repos/5909fa5c31ca0a026f0001c9/feed)

入伙 API 端

## System dependencies

* Ruby version 2.4.1
* System dependencies
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions

### Gems

* [active_type](https://github.com/makandra/active_type)
* [active_model_serializers](https://github.com/rails-api/active_model_serializers)

## 测试

```
bin/rails db:migrate RAILS_ENV=test
rake
CODECLIMATE_REPO_TOKEN=<token> bundle exec codeclimate-test-reporter
```
