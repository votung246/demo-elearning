module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    #@current_user ||= User.find_by id: session[:user_id]
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user? user
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget current_user
    session[:user_id] = nil
    @current_user = nil
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
