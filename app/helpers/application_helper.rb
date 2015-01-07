module ApplicationHelper
  def myself?(user)
    user_signed_in? && current_user.id == user.id
  end

  def gravatar_image_tag(user)
    image_tag("http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}", class: 'gravater_icon')
  end
end
