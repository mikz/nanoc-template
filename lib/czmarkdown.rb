require "haml"

module Haml::Filters::Czmarkdown
  include Haml::Filters::Base

  # copied from Haml::Filters::Markdown
  lazy_require 'rdiscount', 'peg_markdown', 'maruku', 'bluecloth'
  def render(text)
    # copied from Haml::Filters::Markdown
    engine = case @required
             when 'rdiscount'
               ::RDiscount
             when 'peg_markdown'
               ::PEGMarkdown
             when 'maruku'
               ::Maruku
             when 'bluecloth'
               ::BlueCloth
             end
    engine.new(cz text).to_html  # gfm method defined elsewhere
  end
end