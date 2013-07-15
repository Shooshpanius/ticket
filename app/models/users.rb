class Users < ActiveRecord::Base

  has_many :users_by_groups
  has_many :groups, through: :users_by_groups

end
