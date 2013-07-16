class Groups < ActiveRecord::Base

  has_many :user_by_group, :foreign_key => :groups_id, dependent: :destroy
  has_many :users, through: :user_by_group

end
