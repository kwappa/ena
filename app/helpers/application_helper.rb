module ApplicationHelper
  def myself?(user)
    user_signed_in? && current_user.id == user.id
  end

  def gravatar_image_tag(user)
    image_tag("http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}", class: 'gravatar_icon')
  end

  def user_suspend_icon_tag(user)
    return "" if user.active?
    content_tag :i, "", class: "fa fa-#{user.suspend_status_fa_icon} fa-lg"
  end
end
