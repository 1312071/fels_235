module ApplicationHelper
  def full_title page_title = ""
    base_title = t ".application_name"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def index_for counter, page, per_page
    (page - 1) * per_page + counter + 1
  end
end
