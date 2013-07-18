class Users < ActiveRecord::Base

  has_many :user_by_group, :foreign_key => :users_id, dependent: :destroy
  has_many :ticket_comments, dependent: :destroy
  has_many :ticket_to_user, dependent: :destroy
  has_many :groups, through: :user_by_group

end
