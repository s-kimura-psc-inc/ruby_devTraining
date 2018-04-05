class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user
  before_action :require_user

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url
  end

  private

  # ログイン中のセッションを取得します。
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  # ログイン中のユーザを取得します。
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # ログインしているかどうかを検証します。<br>
  # ログインしていなければ、ログイン画面にリダイレクトします。
  #
  # @return [Boolean] ログインしている場合は`true`
  def require_user
    return true if current_user
    redirect_to login_url
    false
  end
  
  # ロケールをデフォルトのロケール（日本語）に変更します。
  def set_locale_default
    I18n.locale = I18n.default_locale
  end

  def logged_in?
    current_user_session != nil
  end

  # エラーログを出力します。
  #
  # @param message [String] エラーメッセージ
  def error_log(message)
    Rails.logger.error "[#{controller_name}/#{action_name}] #{message}" if message.present?
  end
end
