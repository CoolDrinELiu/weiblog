class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "请先登陆"
      redirect_to signin_path
    end
  end



end
