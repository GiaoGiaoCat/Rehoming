# http://ridingtheclutch.com/post/71345006944/how-to-add-directories-to-rake-stats

task stats: 'dev:stats'
namespace :dev do
  desc 'Rebuild system'
  task build: ['tmp:clear', 'log:clear', 'db:drop', 'db:create', 'db:migrate']
  task rebuild: ['dev:build', 'db:seed']

  task :stats do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ['Services', 'app/services']
    ::STATS_DIRECTORIES << ['Services Tests', 'test/services']
    CodeStatistics::TEST_TYPES << 'Services Tests'
  end
end
