class ActualTask < ActiveRecord::Base

  belongs_to :user
  belongs_to :ticket_to_group
  belongs_to :ticket_to_user

end
