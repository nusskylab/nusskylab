module ApplicationHelper
  def javascript(*files)
    content_for(:js_head) { javascript_include_tag(*files) }
  end
end
