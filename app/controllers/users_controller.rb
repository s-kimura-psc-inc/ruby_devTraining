class UsersController < ApplicationController
  # メッセージ
  MESSAGES = {
    create_notice:  'ユーザを登録しました',
    update_notice:  'ユーザ情報を更新しました',
    destroy_notice: 'ユーザを削除しました',
    destroy_alert:  'ユーザ削除に失敗しました',
    task_destroy_alert: '削除対象ユーザが作成したタスクの削除に失敗しました'
  }.freeze

  before_action :set_user, only: :destroy
  before_action :set_locale_default, expect: :update

  # ユーザ一覧画面を表示する。
  def index
    # 管理者ユーザかどうか判断
    authorize User.new
    @users = User.user_records();
    
  end

  # ユーザ新規登録画面を表示する。
  def new
    @user = User.new
    authorize @user
  end

  # ユーザを登録する。
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

  #ユーザ更新画面を表示する
  def edit
    #idでTasksテーブルを取得
    @user = User.find(params[:id])
    
  end

  #ユーザを更新する
  def update
    #idでTasksテーブルを取得
    @user = User.find(params[:id])
   
    @user.update(params.require(:user).permit(:user_nm, :authority_level))
   
    #担当者などにログインユーザIDを設定する
    @user.updated_by = current_user.login
    @user.save
    
    if @user.save
      redirect_to users_path, notice: MESSAGES[:update_notice]
    else
      render :edit
    end
  end

  #ユーザから遷移したタスク一覧情報を取得する。
  def show
    #選択したユーザのタスク一覧情報を取得
    @tasks = Task.user_task_list(params[:login])
  end

  # ユーザとユーザの作成したタスクを削除する。
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

  # 指定されたIDのユーザ情報を`@user`インスタンスにセットする。
  def set_user
    @user = User.find(params[:id])
  end

  # 受信したパラメータから許可されたパラメータのみに絞り込む。
  #
  # @return [ActionController::Parameters] 許可されたパラメータ
  def new_user_params
    params.require(:user).permit(%i[login password password_confirmation user_nm authority_level])
  end

end
