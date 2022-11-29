module ApplicationHelper
  FLASH_CLASS = {
    alert: 'danger',
    notice: 'success'
  }.freeze

  def flash_message(message, type)
    content_tag :div, message.html_safe, class: ["alert alert-#{FLASH_CLASS[type.to_sym]}", "m-3"], role: "alert"
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
