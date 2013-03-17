# http://my.rails-royce.org/2010/07/21/email-validation-in-ruby-on-rails-without-regexp/
require "mail"

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      valid = false
      mail_address = Mail::Address.new(value)
      # We must check that value contains a domain and that value is an email address
      valid = mail_address.domain && mail_address.address == value
      tree = mail_address.__send__(:tree)
      # We need to dig into treetop
      # A valid domain must have dot_atom_text elements size > 1
      # user@localhost is excluded
      # treetop must respond to domain
      # We exclude valid email values like <user@localhost.com>
      # Hence we use mail_address.__send__(tree).domain
      valid = valid and (tree.domain.dot_atom_text.elements.size > 1)
    rescue Exception => ex
      valid = false
    end
    record.errors[attribute] << (options[:message] || "is invalid") unless valid
  end
end
