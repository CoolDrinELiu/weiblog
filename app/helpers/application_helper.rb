module ApplicationHelper
	def full_title( page_title)
base_title = "Ruby on Rails "
if page_title.empty?
base_title
else
"#{base_title} | #{page_title}"
end
  end
  def time_check
    if Time.now.hour>5 && Time.now.hour<12
      "上午好"
    else
      "下午好"
    end
  end
end
