class Groups < ActiveRecord::Base
  has_many :users_by_groups, dependent: :destroy
  has_many :users, through: :users_by_groups
end
