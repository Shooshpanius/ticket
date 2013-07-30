class Problem < ActiveRecord::Base
  has_many :ticket_comments, dependent: :destroy

end
