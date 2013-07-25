class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def pass_generate(len=7) chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a - ['o', 'O', 'i', 'I']
  return Array.new(len) { chars[rand(chars.size)] }.join
  end

end

#
#def is_admin
#
#  if session[:is_login] = true
#    redirect_to login2
#  else
#    redirect_to login_url
#  end
#
#
#end