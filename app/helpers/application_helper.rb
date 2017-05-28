module ApplicationHelper
  def header(text)
    content_for(:header) {text.to_s}
  end

  def full_title(page_title = '')
    base_title = 'TvSeries4U'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def flash_class(level)
    'alert alert-success' if level == :notice
    'alert alert-success' if level == :success
    'alert alert-error' if level == :error
    'alert alert-warning' if level == :alert
  end
end
