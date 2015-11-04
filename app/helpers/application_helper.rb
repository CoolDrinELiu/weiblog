module ApplicationHelper
	def full_title(page_title)
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

  def markdown(text)
    options = {
        :autolink => true,
        :space_after_headers => true,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true,
        :hard_wrap => true,
        :strikethrough =>true
    }
    markdown = Redcarpet::Markdown.new(HTMLwithCodeRay,options)
    markdown.render(h(text)).html_safe
  end

  class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div(:tab_width=>2)
    end
  end

end
