module ApplicationHelper
  def myself?(user)
    user_signed_in? && current_user.id == user.id
  end
end
