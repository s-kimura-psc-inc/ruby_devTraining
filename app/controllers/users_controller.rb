class UsersController < ApplicationController
  # メッセージ
  MESSAGES = {
    create_notice:  'ユーザを登録しました',
    update_notice:  'パスワードを更新しました',
    destroy_notice: 'ユーザを削除しました',
    destroy_alert:  'ユーザ削除に失敗しました',
    task_destroy_alert: '削除対象ユーザが作成したタスクの削除に失敗しました'
  }.freeze

  before_action :set_user, only: :destroy
  before_action :set_locale_default, expect: :update
  before_action :set_locale_en, only: :update

  # ユーザ一覧画面を表示します。
  def index
    @users = User.user_records();
    
  end

  # ユーザ新規登録画面を表示します。
  def new
    @user = User.new
    authorize @user
  end

  # パスワード変更画面を表示します。
#  def edit
#    @user = current_user
#    authorize @user
#  end

  # ユーザを登録します。
  def create
    @user = User.new(new_user_params)
    authorize @user

    @user.created_by = current_user.login
    @user.updated_by = current_user.login

    if @user.save
      redirect_to new_user_url, notice: MESSAGES[:create_notice]
    else
      render :new
    end
  end

  # ユーザを削除します。
  def destroy
    
    @user = User.find(params[:id])
    
    @user.destroy_with_task!(params[:login])
    
    flash[:msg] =  MESSAGES[:destroy_notice]
  rescue => e
    flash[:alert] = MESSAGES[:destroy_alert]
    error_log(MESSAGES[:destroy_alert])
    error_log(e.message)
  ensure
    redirect_to users_url
  end

  private

  # 指定されたIDのユーザ情報を`@user`インスタンスにセットします。
  def set_user
    @user = User.find(params[:id])
  end

  # 受信したパラメータから許可されたパラメータのみに絞り込みます（ユーザ新規登録用）。
  #
  # @return [ActionController::Parameters] 許可されたパラメータ
  def new_user_params
    params.require(:user).permit(%i[login password password_confirmation user_nm authority_level])
  end

  # 受信したパラメータから許可されたパラメータのみに絞り込みます（ユーザ更新用）。
  #
  # @return [ActionController::Parameters] 許可されたパラメータ
#  def edit_user_params
#    params.require(:user).permit(%i[old_password password password_confirmation])
#  end
end
