class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user
  before_action :require_user

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url
  end

  private

  # ���O�C�����̃Z�b�V�������擾���܂��B
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  # ���O�C�����̃��[�U���擾���܂��B
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # ���O�C�����Ă��邩�ǂ��������؂��܂��B<br>
  # ���O�C�����Ă��Ȃ���΁A���O�C����ʂɃ��_�C���N�g���܂��B
  #
  # @return [Boolean] ���O�C�����Ă���ꍇ��`true`
  def require_user
    return true if current_user
    redirect_to login_url
    false
  end
  
  # ���P�[�����f�t�H���g�̃��P�[���i���{��j�ɕύX���܂��B
  def set_locale_default
    I18n.locale = I18n.default_locale
  end

  def logged_in?
    current_user_session != nil
  end

  # �G���[���O���o�͂��܂��B
  #
  # @param message [String] �G���[���b�Z�[�W
  def error_log(message)
    Rails.logger.error "[#{controller_name}/#{action_name}] #{message}" if message.present?
  end
end
