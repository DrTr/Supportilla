module Supportilla
  class Staff < ActiveRecord::Base
    attr_accessible :admin, :password_digest, :username
  end
end
