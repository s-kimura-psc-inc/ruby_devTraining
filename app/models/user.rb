class User < ApplicationRecord
  attr_accessor :old_password

  validates :login, presence: true, length: { maximum: 20 }
  validates :user_nm, length: { maximum: 50 }
  #validates :authority_level, presence: true, inclusion: { in: [1, 2], allow_nil: true }

  acts_as_authentic do |c|
    # �f�t�H���g�� /\A[a-zA-Z0-9_][a-zA-Z0-9\.+\-_@ ]+\z/ ����ύX���A1�����ŃG���[�ƂȂ�Ȃ��悤�ɂ���
    # https://github.com/binarylogic/authlogic/blob/v3.6.0/lib/authlogic/regex.rb#L44
    c.merge_validates_format_of_login_field_options(with: /\A[a-zA-Z0-9_][a-zA-Z0-9\.+\-_@ ]*\z/)

    # �f�t�H���g�� { :within => 3..100 } ����ύX���Aauthlogic�ł͒����G���[�ƂȂ�Ȃ��悤�ɂ���
    # https://github.com/binarylogic/authlogic/blob/v3.6.0/lib/authlogic/acts_as_authentic/login.rb#L43
    c.merge_validates_length_of_login_field_options(within: 0..255)

    c.validates_format_of :password,
      with: Authlogic::Regex.login,
      message: I18n.t('authlogic.error_messages.login_invalid'),
      if: :require_password?
    c.merge_validates_length_of_password_field_options(minimum: 8, maximum: 20)
  end
  
  # ���[�U�ꗗ���(�^�X�N�J�E���g�t��)���擾����
  #
  # @param
  # @return [ActiveRecord::Result] �擾�����f�[�^
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

  # �Ώۃ��[�U���쐬�����^�X�N�폜�ƑΏۃ��[�U���폜����B�B
  #
  # @param user_id [String] ���[�UID
  def destroy_with_task!(user_id)
    ApplicationRecord.transaction do
      destroy!
      Task.destroy_user_task!(user_id)
    end
  end

  # ���[�U�̌������x�����u��ʃ��[�U�v���ǂ����𔻒�
  #
  # @return [Boolean] �f�[�^�G���g���[�̏ꍇ��`true`
  def general?
    authority_level == Constants::AUTHORITY_LEVEL_GENERAL[:value]
  end

  # ���[�U�̌������x�����u�Ǘ��ҁv���ǂ����𔻒�
  #
  # @return [Boolean] �Ǘ��҂̏ꍇ��`true`
  def admin?
    authority_level == Constants::AUTHORITY_LEVEL_ADMIN[:value]
  end

  # �w�肵�����[�U��ID�����g�̃C���X�^���X��ID�Ɠ������ǂ����𔻒肵�܂��B
  #
  # @param user [User] ��r�Ώۃ��[�U
  # @return [Boolean] �����ꍇ��`true`
  def me?(user)
    id == user.id
  end
end
