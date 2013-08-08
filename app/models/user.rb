class User < ActiveRecord::Base

  has_many :user_by_groups, dependent: :destroy
  has_many :ticket_comments, dependent: :destroy
  has_many :ticket_to_users, dependent: :destroy
  has_many :groups, through: :user_by_groups


  after_create :send_welcome_email

  def send_welcome_email
    TicketMailer.send_welcome_email(self).deliver
  end


end
