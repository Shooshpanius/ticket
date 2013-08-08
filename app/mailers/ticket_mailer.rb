class TicketMailer < ActionMailer::Base
  default from: "test@velskiyles.ru"

  def welcome_email(user)
    @user = user
    @url  = 'http://web.wood.local/login'
    mail(to: user.email, subject: 'Добро пожаловать с систему управления заявками')
  end
end
