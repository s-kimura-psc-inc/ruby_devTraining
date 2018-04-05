# ユーザモデルアクセス制御ポリシー
class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def new?
    admin?
  end

  def edit?
    me?
  end

  def create?
    admin?
  end

  def update?
    me?
  end

  def destroy?
    admin? && !me?
  end

  private

  def me?
    user.me?(record)
  end
end
