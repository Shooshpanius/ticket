class Group < ActiveRecord::Base

  has_many :user_by_groups, dependent: :destroy
  has_many :ticket_to_groups, dependent: :destroy
  has_many :users, through: :user_by_groups

end
