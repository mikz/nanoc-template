# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
def layout
  @layouts.first
end

def images images = @item[:images]
  pattern = /\/images\/(#{(images||[]).join("|")})\//i
  @items.select do |item|
    item.identifier =~ pattern
  end
end


def find_items ident
  ident.gsub!("*", "(.+)")
  regexp = /\A#{ident}\Z/
  items.select {|i|
    i.identifier =~ regexp
  }
end

def find_item ident
  find_items(ident).first
end


def title *elements
  elements.flatten.join(" :: ")
end

def title_path item, attr = :title
  items = [item]
  while item.parent && item.parent.identifier != "/"
    item = item.parent
    items << item
  end
  items.map!{|i| i[:title] }
end


def seo(text, space = "-")
  I18n.transliterate(text).downcase.gsub(/\W/, space)
end

def cz(text)
 text.gsub(/ {2,}/," ").gsub(/(\s)((A|a)|(I|i)|(O|o)|(U|u)|(K|k)|(S|s)|(V|v)|(Z|z)|by|(P|p)ř(ed|i|)|(Č|č)i|(K|k)u|(O|o)d|(C|c|D|d|N|n|T|t|P|p)o|(N|n|T|t|Z|z)a|(Ž|ž|Z|z|V|v|J|j|K|k|S|s)e|(A|a)by|(C|c)ož|(K|k)d(e|y)|(K|k)ter(ý|á|é)|(N|n)ad|(P|p)od)\s/, '\1\2&#160;')
end