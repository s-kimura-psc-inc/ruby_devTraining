# ラベルモデルアクセス制御ポリシー
class LabelPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end
end
