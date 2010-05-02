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
        return if options[:allow_blank] && value.blank?
        
        unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
          record.errors[attribute] << (options[:message])
          return
        end
      end
    end
    
    module ClassMethods

      # Validates that the specified attribute is a valid email address.
      # 
      # Configuration options:
      # * <tt>:allow_nil</tt> - Attribute may be +nil+; skip validation.
      # * <tt>:allow_blank</tt> - Attribute may be blank; skip validation.
      # * <tt>:message</tt> - The error message to be displayed
      # * <tt>:on</tt> - Specifies when this validation is active (default is <tt>:save</tt>, other options <tt>:create</tt>, <tt>:update</tt>).
      # * <tt>:if</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   occur (e.g. <tt>:if => :allow_validation</tt>, or <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>).  The
      #   method, proc or string should return or evaluate to a true or false value.
      # * <tt>:unless</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   not occur (e.g. <tt>:unless => :skip_validation</tt>, or <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>).  The
      #   method, proc or string should return or evaluate to a true or false value.
      def validates_as_email(*attr_names)
        validates_with EmailValidator, _merge_attributes(attr_names)
      end
    end
  end
end
