module ApplicationHelper
  def myself?(user)
    user_signed_in? && current_user.id == user.id
  end

  def gravatar_image_tag(user, extra_options = {})
    options = extra_options.dup

    if options[:class].present?
      options[:class] = options[:class].split(/\s/).push('gravatar_icon').join(' ')
    else
      options[:class] = 'gravatar_icon'
    end

    image_tag("http://gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}", options)
  end

  def user_suspend_icon_tag(user)
    return "" if user.active?
    content_tag :i, "", class: "fa fa-#{user.suspend_status_fa_icon} fa-lg"
  end

  def user_name_tag(user)
    content_tag :ruby do
      content_tag(:rb, user.screen_name).html_safe << content_tag(:rt, user.screen_name_kana)
    end
  end

  def permitted_user?(action)
    user_signed_in? && current_user.permitted?(action)
  end
end
