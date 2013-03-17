ENV["TEXTDOMAIN"] = nil
FastGettext.add_text_domain 'qa', path: 'po', type: :po
FastGettext.default_available_locales = ['ja','en'] #all you want to allow
FastGettext.default_text_domain = 'qa'

Qa::Application.config.gettext_i18n_rails.msgmerge = %w[--sort-output --no-wrap]
