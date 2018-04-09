class User < ApplicationRecord
  attr_accessor :old_password

  validates :login, presence: true, length: { maximum: 20 }
  validates :user_nm, length: { maximum: 50 }
  #validates :authority_level, presence: true, inclusion: { in: [1, 2], allow_nil: true }

  acts_as_authentic do |c|
    # デフォルトの /\A[a-zA-Z0-9_][a-zA-Z0-9\.+\-_@ ]+\z/ から変更し、1文字でエラーとならないようにする
    # https://github.com/binarylogic/authlogic/blob/v3.6.0/lib/authlogic/regex.rb#L44
    c.merge_validates_format_of_login_field_options(with: /\A[a-zA-Z0-9_][a-zA-Z0-9\.+\-_@ ]*\z/)

    # デフォルトの { :within => 3..100 } から変更し、authlogicでは長さエラーとならないようにする
    # https://github.com/binarylogic/authlogic/blob/v3.6.0/lib/authlogic/acts_as_authentic/login.rb#L43
    c.merge_validates_length_of_login_field_options(within: 0..255)

    c.validates_format_of :password,
      with: Authlogic::Regex.login,
      message: I18n.t('authlogic.error_messages.login_invalid'),
      if: :require_password?
    c.merge_validates_length_of_password_field_options(minimum: 8, maximum: 20)
  end
  
  # ユーザ一覧情報(タスクカウント付き)を取得する
  #
  # @param
  # @return [ActiveRecord::Result] 取得したデータ
  def self.user_records()
      sql = <<~SQL
      SELECT
        u.id id,
        u.login login,
        u.user_nm user_nm,
        u.authority_level authority_level,
        task.task_cnt task_cnt
      FROM
        #{table_name} u
           LEFT OUTER JOIN 
             (SELECT
                personnel, count(personnel) task_cnt
              FROM
                #{Task.table_name}
              GROUP BY personnel) task ON (
             task.personnel = u.login
           )
    SQL
    
    sql = ApplicationRecord.send(:sanitize_sql_array, [sql.gsub(/\s+/, ' ')])
    ApplicationRecord.connection.select_all(sql)
  end

  # 対象ユーザが作成したタスク削除と対象ユーザを削除する。。
  #
  # @param user_id [String] ユーザID
  def destroy_with_task!(user_id)
    ApplicationRecord.transaction do
      destroy!
      Task.destroy_user_task!(user_id)
    end
  end

  # ユーザの権限レベルが「一般ユーザ」かどうかを判定
  #
  # @return [Boolean] データエントリーの場合は`true`
  def general?
    authority_level == Constants::AUTHORITY_LEVEL_GENERAL[:value]
  end

  # ユーザの権限レベルが「管理者」かどうかを判定
  #
  # @return [Boolean] 管理者の場合は`true`
  def admin?
    authority_level == Constants::AUTHORITY_LEVEL_ADMIN[:value]
  end

  # 指定したユーザのIDが自身のインスタンスのIDと同じかどうかを判定します。
  #
  # @param user [User] 比較対象ユーザ
  # @return [Boolean] 同じ場合は`true`
  def me?(user)
    id == user.id
  end
end
