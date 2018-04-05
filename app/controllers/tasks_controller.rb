class TasksController < ApplicationController

  helper_method :sort_column, :sort_direction

  # メッセージ
  MESSAGES = {
    create_notice:   'タスクを登録しました',
    update_notice:   'タスクを変更しました',
    destroy_notice:  'タスクを削除しました',
    destroy_alert:   'タスク削除に失敗しました'
  }.freeze

  # タスク一覧取得時の結合条件
  LEFT_JOIN = {
    mst_labels:   "LEFT OUTER JOIN mst_labels ON tbl_task_infs.label_cd = mst_labels.label_cd",
    mst_statuses:   "LEFT OUTER JOIN mst_statuses ON tbl_task_infs.status_cd = mst_statuses.status_cd",
    mst_priorities:  "LEFT OUTER JOIN mst_priorities ON tbl_task_infs.priority_cd = mst_priorities.priority_cd"
  }.freeze

  # タスク一覧画面を表示する
  def index
    
    # 絞込み条件をセット
    # -------------------------------------------------------------------------
    where_conditions = ''
    
    if current_user.general?
      where_conditions = "tbl_task_infs.personnel = '" + current_user.login + "'"
    end
    
    # ステータス検索があり、ステータスコードに数値が設定されている場合
    if params[:status_cd].present? && params[:status_cd] =~ /^[0-9]+$/
      if where_conditions == ''
        where_conditions = "tbl_task_infs.status_cd = " + params[:status_cd]
      else
        where_conditions = where_conditions + " and tbl_task_infs.status_cd = " + params[:status_cd]
      end
    end
    
    # タスク名検索がある場合
    if params[:task_nm].present?
      if where_conditions == ''
        where_conditions = "tbl_task_infs.task_nm like ?", params[:task_nm] + "%"
      else
        where_conditions = where_conditions + " and tbl_task_infs.task_nm like ?", params[:task_nm] + "%"
      end
    end
        
    # 検索条件がない場合
    if where_conditions == ''
      where_conditions = "1 = 1"
    end
    # -------------------------------------------------------------------------
    
    # ソート条件をセット
    sort = ''
    if sort_column == 'updated_at'
      sort = 'tbl_task_infs.updated_at desc'
    else
      sort = 'tbl_task_infs.' + sort_column + ' ' + sort_direction
    end
    
    # タスク一覧取得
    @tasks = Task.joins(LEFT_JOIN[:mst_labels]).joins(LEFT_JOIN[:mst_statuses]).joins(LEFT_JOIN[:mst_priorities])
                 .select("tbl_task_infs.*")
                 .select("mst_labels.label_nm").select("mst_statuses.status_nm").select("mst_priorities.priority_nm")
                 .where(where_conditions)
                 .order(sort)
                 .page(params[:page]).per(10)
    
    # ステータス情報取得
    set_status_select_options
  end

  #タスク詳細画面を表示する
  def show
    #idでTasksテーブルを取得
    @tasks = Task.joins(LEFT_JOIN[:mst_labels]).joins(LEFT_JOIN[:mst_statuses]).joins(LEFT_JOIN[:mst_priorities])
                 .select("tbl_task_infs.*")
                 .select("mst_labels.label_nm").select("mst_statuses.status_nm").select("mst_priorities.priority_nm")
                 .where("tbl_task_infs.id = " + params[:id])
  end

  # タスク新規登録画面を表示する
  def new
    @task = Task.new
    set_label_select_options
    set_status_select_options
    set_priority_select_options
  end

  # タスクを登録する
  def create
    @task = Task.new(task_params)
    
    #担当者などにログインユーザIDを設定する
    @task.personnel = current_user.login
    @task.created_by = current_user.login
    @task.updated_by = current_user.login

    if @task.save
      redirect_to tasks_path, notice: MESSAGES[:create_notice]
    else
      set_label_select_options
      set_status_select_options
      set_priority_select_options
      
      render :new
    end
  end

  #タスク更新画面を表示する
  def edit
    #idでTasksテーブルを取得
    @task = Task.find(params[:id])
    
    set_label_select_options
    set_status_select_options
    set_priority_select_options
  end

  #タスクを更新する
  def update
    #idでTasksテーブルを取得
    @task = Task.find(params[:id])
    
    @task.update(params.require(:task).permit(:task_nm, :task, :deadline, :status_cd, :priority_cd))
   
    #担当者などにログインユーザIDを設定する
    @task.personnel = current_user.login
    @task.updated_by = current_user.login
    @task.save
    
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
  
  # ユーザ削除時にユーザに紐付くタスクを削除する
  def userTask_destroy(user_id)
    #idでTasksテーブルを取得
    @task = Task.where("personnel = " + user_id)

    #削除処理
    @task.destroy
    @task.save
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
      :status_cd,
      :priority_cd
    )
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
  
  # 昇順、降順判定
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
  
  # ソートするカラム
  def sort_column
      Task.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end

end
