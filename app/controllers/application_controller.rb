class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end


def is_admin

  if session[:is_admin]

  else
    redirect_to login_url
  end


end