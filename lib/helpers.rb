require File.expand_path("../rails", __FILE__)

include Nanoc3::Helpers::Rendering
module Nanoc3::Helpers::LinkTo
  def link_to(text, target, attributes={})
    # Find path
    path = target.is_a?(String) ? target : target.path

    if @item_rep && @item_rep.path == path
      attributes[:class] ||= ""
      attributes[:class] =  attributes[:class].split(" ").push("active").join(" ")
    end

    # Join attributes
    attributes = attributes.inject('') do |memo, (key, value)|
      memo + key.to_s + '="' + h(value) + '" '
    end
    

    # Create link
    "<a #{attributes}href=\"#{h path}\">#{text}</a>"
  end
end
include Nanoc3::Helpers::LinkTo

module Nanoc3::Helpers::Capturing
  def content_for(name, output = nil, &block)
    eval %{
      @item[:content_for_#{name.to_s}] ||= ""
      if block_given?
        @item[:content_for_#{name.to_s}] << capture(&block)
      elsif output
        @item[:content_for_#{name.to_s}] << output
      end
    }
  end
end
include Nanoc3::Helpers::Capturing

def sidebar &block
  content_for :sidebar, "<div class='row'>"
  content_for :sidebar, &block
  content_for :sidebar, "</div>"
end

module I18nHelpers
  def localize(*args)
    I18n.localize(*args)
  end
  alias :l :localize
  
  def translate(key, options = {})
    I18n.translate(key, options.merge!(:raise => true))
  end
  alias :t :translate
end
include I18nHelpers

def partial identifier, other_assigns = {}, &block
  render identifier.insert(0, "_"), other_assigns, &block
end


