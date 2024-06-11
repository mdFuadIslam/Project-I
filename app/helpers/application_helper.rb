module ApplicationHelper
  require 'redcarpet'
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    extensions = {
      tables: true,
      autolink: true,
      strikethrough: true,
      footnotes: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      no_intra_emphasis: true,
      superscript: true
    }
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end
end
