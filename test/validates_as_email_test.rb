require 'test/unit'

require File.dirname(__FILE__) + '/../../../../config/boot'
require 'active_model'
require 'validates_as_email'


class TestRecord
  include ActiveModel::Validations
  attr_accessor :email
  def initialize(email)
    @email = email
  end
  validates :email, :email => true
end

class ValidatesAsEmailTest < Test::Unit::TestCase
  def test_illegal_email_address
    addresses = [
      'Max@Job 3:14', 
      'Job@Book of Job',
      'J. P. \'s-Gravezande, a.k.a. The Hacker!@example.com',
      'Nobody',
      'Nobody@Knows',
      '"J. P. \'s-Gravezande, a.k.a. The Hacker!"@example.com',
      'me@[187.223.45.119]',
      ]
    addresses.each do |address|
      assert !TestRecord.new(address).valid?, "#{address} should be illegal."
    end
  end

  def test_legal_email_address
    addresses = [
      'test@example.com', 
      'test@example.co.uk',
      'someone@123.com',
      ]
    addresses.each do |address|
      assert TestRecord.new(address).valid?, "#{address} should be legal."
    end
  end
end
