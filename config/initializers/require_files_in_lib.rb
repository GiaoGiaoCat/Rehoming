# http://wjp2013.github.io/rails/Auto-loading-lib-files-in-Rails-4/
Dir[Rails.root + 'lib/**/*.rb'].each { |file| require file }
