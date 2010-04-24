# encoding: utf-8

# Validation helper for ActiveRecord derived objects that cleanly and simply
# allows the model to check if the given string is a valid email
# address.
# 
# This code does not comply with any RFC as I don't find usual to do so,
# if you don't agree with me, please read: http://www.dominicsayers.com/isemail/
#
# Original code by Ximon Eighteen <ximon.eightee@int.greenpeace.org> which was
# heavily based on code I can no longer find on the net, my apologies to the
# author!
# 

module ActiveModel
  module Validations
    class EmailValidator < EachValidator
      def initialize(options)
        configuration = {
          :message   => (I18n.translate(:'activerecord.errors.messages.invalid_email', :raise => true) rescue 'is an invalid email address'),
          :allow_nil => false
        }
        super(options.reverse_merge(configuration))
      end
  
      def validate_each(record, attribute, value)
        
        return if options[:allow_nil] && value.nil?
        
        unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
          record.errors[attribute] << (options[:message])
          return
        end
      end
    end
    
    module ClassMethods
      def validates_as_email(*attr_names)
        validates_with EmailValidator, _merge_attributes(attr_names)
      end
    end
  end
end
