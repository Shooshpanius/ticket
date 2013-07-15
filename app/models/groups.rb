class Groups < ActiveRecord::Base
  has_many :users_by_groups
  has_many :users, through: :users_by_groups
end
