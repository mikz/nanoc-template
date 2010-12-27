require "active_support/concern"
require "action_dispatch/http/mime_type"
require "action_view/helpers/capture_helper"
require "action_view/helpers/tag_helper"
include ActionView::Helpers::TagHelper


def mail_to(email_address, name = nil, html_options = {})
  email_address = html_escape(email_address)
 
  html_options = html_options.stringify_keys
  encode = html_options.delete("encode").to_s
  cc, bcc, subject, body = html_options.delete("cc"), html_options.delete("bcc"), html_options.delete("subject"), html_options.delete("body")
 
  extras = []
  extras << "cc=#{Rack::Utils.escape(cc).gsub("+", "%20")}" unless cc.nil?
  extras << "bcc=#{Rack::Utils.escape(bcc).gsub("+", "%20")}" unless bcc.nil?
  extras << "body=#{Rack::Utils.escape(body).gsub("+", "%20")}" unless body.nil?
  extras << "subject=#{Rack::Utils.escape(subject).gsub("+", "%20")}" unless subject.nil?
  extras = extras.empty? ? '' : '?' + html_escape(extras.join('&'))
 
  email_address_obfuscated = email_address.dup
  email_address_obfuscated.gsub!(/@/, html_options.delete("replace_at")) if html_options.has_key?("replace_at")
  email_address_obfuscated.gsub!(/\./, html_options.delete("replace_dot")) if html_options.has_key?("replace_dot")
 
  string = ''
 
  if encode == "javascript"
    "document.write('#{content_tag("a", name || email_address_obfuscated.html_safe, html_options.merge("href" => "mailto:#{email_address}#{extras}".html_safe))}');".each_byte do |c|
      string << sprintf("%%%x", c)
    end
    "<script type=\"#{Mime::JS}\">eval(decodeURIComponent('#{string}'))</script>".html_safe
  elsif encode == "hex"
    email_address_encoded = ''
    email_address_obfuscated.each_byte do |c|
      email_address_encoded << sprintf("&#%d;", c)
    end
 
    protocol = 'mailto:'
    protocol.each_byte { |c| string << sprintf("&#%d;", c) }
 
    email_address.each_byte do |c|
      char = c.chr
      string << (char =~ /\w/ ? sprintf("%%%x", c) : char)
    end
    content_tag "a", name || email_address_encoded.html_safe, html_options.merge("href" => "#{string}#{extras}".html_safe)
  else
    content_tag "a", name || email_address_obfuscated.html_safe, html_options.merge("href" => "mailto:#{email_address}#{extras}".html_safe)
  end
end