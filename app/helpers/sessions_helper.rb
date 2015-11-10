module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
    cookies.permanent[:user_name] = user.name
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # def sign_in(user)
  #   remember_token = User.new_remember_token
  #   cookies.permanent[:remember_token] = remember_token
  #   cookies.permanent[:user_name] = user.name
  #   user.update_attribute(:remember_token, User.encrypt(remember_token))
  #   self.current_user= user
  # end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  def current_user=(user)
    @current_user = user
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user == current_user
  end

  # def signed_in?
  #   !current_user.nil?
  # end
  def logged_in?
    !current_user.nil?
  end

  # def signed_in_user
  #   unless signed_in?
  #     store_location
  #     redirect_to signin_url, notice: "请先登陆。" unless signed_in?
  #   end
  # end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

end
