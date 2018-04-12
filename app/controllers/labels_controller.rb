class LabelsController < ApplicationController

  # メッセージ
  MESSAGES = {
    create_notice:  'ラベルを登録しました',
    destroy_notice: 'ラベルを削除しました',
    destroy_alert:  'ラベル削除に失敗しました'
  }.freeze

  # ラベル一覧画面を表示する。
  def index
    authorize Label.new
    @labels = Label.label_list;
  end

  # ラベル新規登録画面を表示する。
  def new
    authorize Label.new
    @label = Label.new
  end

  # ラベルを登録する。
  def create
    @label = Label.new(new_label_params)

    if @label.save
      redirect_to new_label_url, notice: MESSAGES[:create_notice]
    else
      render :new
    end
  end
  
  # ラベル一覧画面 削除ボタン押下時のアクション
  def destroy
    @label = Label.find(params[:id])

    #削除処理（delete文発行）
    @label.destroy

    if @label.save
      flash[:msg] =  MESSAGES[:destroy_notice]
    else
      flash[:msg] =  MESSAGES[:destroy_alert]
    end

    #呼び出し元URLへリダイレクト
    redirect_to request.referer
  end

  private

  # 受信したパラメータから許可されたパラメータのみに絞り込む。
  #
  # @return [ActionController::Parameters] 許可されたパラメータ
  def new_label_params
    params.require(:label).permit(%i[label_cd label_nm])
  end

end
