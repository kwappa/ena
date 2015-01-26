module AuthorityHelper
  def permitted_user?(action)
    user_signed_in? && current_user.permitted?(action)
  end
end
