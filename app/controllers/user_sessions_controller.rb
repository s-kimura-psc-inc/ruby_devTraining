class UserSessionsController < ApplicationController

  # メッセージ
  MESSAGES = {
    create_alert: 'ログインに失敗しました。'
  }.freeze

  layout false
  skip_before_action :require_user, only: [:new, :create]

  # ログイン画面を表示します。
  def new
    @user_session = UserSession.new
  end

  # ログイン処理を行い、トップ画面にリダイレクトします。
  def create
    @user_session = UserSession.new(user_session_params)
    
    if @user_session.save
      redirect_to root_url
    else
      flash.now[:alert] = MESSAGES[:create_alert]
      error_log(MESSAGES[:create_alert])

      render action: :new
    end
  end

  # ログアウト処理を行い、ログイン画面にリダイレクトします。
  def destroy
    current_user_session.destroy
    redirect_to login_url
  end

  private

  # 受信したパラメータから許可されたパラメータのみに絞り込みます。
  #
  # @return [ActionController::Parameters] 許可されたパラメータ
  def user_session_params
    params.require(:user_session).permit(:login, :password)
  end

end
