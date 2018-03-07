class TasksController < ApplicationController

  # メッセージ
  MESSAGES = {
    create_notice:  'タスクを登録しました',
    update_notice:  'タスクを変更しました',
    destroy_notice: 'タスクを削除しました',
    destroy_alert:  'タスク削除に失敗しました'
  }.freeze

  # タスク一覧画面を表示する
  def index
    @tasks = Task.task_records(params)
    
    @task = Task.new
    
  end

  #タスク詳細画面を表示する
  def show
    #idでTasksテーブルを取得
    @tasks = Task.task_record(params[:id])
    
    puts("タスク詳細画面")
    
  end

  # タスク新規登録画面を表示する
  def new
    @task = Task.new
    set_label_select_options
    set_priority_select_options
  end

  # タスクを登録する
  def create
    @task = Task.new(task_params)

#    @tasks.created_by = current_user.login
#    @tasks.updated_by = current_user.login
    @task.created_by = "s.kimura"
    @task.updated_by = "s.kimura"

    if @task.save
      redirect_to tasks_path, notice: MESSAGES[:create_notice]
    else
      render :new
    end
  end

  #タスク更新画面を表示する
  def edit
    #idでTasksテーブルを取得
    @task = Task.find(params[:id])
    
    set_label_select_options
    set_priority_select_options
  end

  #タスクを更新する
  def update
    #idでTasksテーブルを取得
    @task = Task.find(params[:id])
    
    @task.update(params.require(:task).permit(:task_nm, :task))
    
    redirect_to tasks_path, notice: MESSAGES[:update_notice]
  end

  # タスク一覧画面 削除ボタン押下時のアクション
  def destroy
    #idでTasksテーブルを取得
    @task = Task.find(params[:id])

    #削除処理（delete文発行）
    @task.destroy

    if @task.save
      flash[:msg] =  MESSAGES[:destroy_notice]
    else
      flash[:msg] =  MESSAGES[:destroy_alert]
    end

    #呼び出し元URLへリダイレクト
    redirect_to request.referer
  end

  # ラベルセレクトボックスの選択肢をセット
  def set_label_select_options
    @label_select_options = Label.select_options
  end
  
  # ステータスセレクトボックスの選択肢をセット
  def set_status_select_options
    @status_select_options = Status.select_options
  end
  
  # 優先度セレクトボックスの選択肢をセット
  def set_priority_select_options
    @priority_select_options = Priority.select_options
  end
  
  #-------------------------
  private
  #-------------------------

  #ストロングパラメータ（マスアサインメント脆弱性回避）
  def task_params
    params.require(:task).permit(
      :label_cd,
      :task_nm,
      :task,
      :deadline,
      :priority_cd
    )
  end

end
