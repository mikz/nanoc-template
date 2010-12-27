I18n.available_locales = %w{cz en}
I18n.default_locale = I18n.available_locales.first
I18n.locale = I18n.default_locale
I18n.load_path = Dir[File.join File.dirname(__FILE__), "locales", "**", "*.{yml,yaml,rb}"]
