module ApplicationHelper
  FLASH_CLASS = {
    alert: 'danger',
    notice: 'success'
  }.freeze

  def flash_message(message, type)
    content_tag :div, message.html_safe, class: ["alert alert-#{FLASH_CLASS[type.to_sym]}", "m-3"], role: "alert"
  end
end
