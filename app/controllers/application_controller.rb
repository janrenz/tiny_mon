# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  before_filter :set_language
  before_filter :authorize

  helper_method :current_user_session, :current_user, :logged_in?

protected
  def method_missing(method, *args)
    if method.to_s =~ /^can_.*\?$/
      if current_user.send(method, *args)
        yield if block_given?
        true
      else
        false
      end
    elsif method.to_s =~ /^can_.*\!$/
      if current_user.send(method.to_s.gsub(/\!$/, '?'), *args)
        yield if block_given?
      else
        flash[:error] = t('flash.error.access_denied')
        redirect_to root_path
        false
      end
    else
      super
    end
  end
  
  def set_language
    if logged_in?
      I18n.locale = current_user.config.language
    else
      I18n.locale = TinyMon::Config.language if TinyMon::Config.language
    end
  end

  def login_required
    deny_access(I18n.t("flash.error.login_required")) unless current_user
  end

  def guest_required
    deny_access(I18n.t("flash.error.guest_required")) if current_user
  end
  
  def deny_access(message = nil)
    store_location
    flash[:error] = message || I18n.t("flash.error.access_denied")
    redirect_to root_path
    return false
  end
  
  def authorize
    deny_access unless authorized?
  end
  
  def authorized?
    true
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def logged_in?
    !current_user.nil?
  end

  def find_account
    @account = params[:account_id] ? Account.find(params[:account_id]) : current_user.current_account
    can_switch_to_account!(@account) do
      if current_user.current_account != @account
        flash[:notice] = I18n.t('flash.notice.switched_account', :account => @account.name)
        current_user.switch_to_account(@account)
      end
    end
  end

private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
end
