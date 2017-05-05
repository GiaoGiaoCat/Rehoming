class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include EncryptedId
  encrypted_id key: 'kwXKxc3zRH3UFz'
end
