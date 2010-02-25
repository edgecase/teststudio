ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'faker'
require 'factory_girl'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false
  # fixtures :all
  
  def assert_uniqueness_of(attribute)
    assert_validation_with_message /has already been taken/, attribute
  end
  
  def assert_presence_of(attribute)
    assert_validation_with_message(/can't be blank/, attribute)
  end
  
  def assert_numericality_of(attribute)
    assert_validation_with_message /is not a number/, attribute
  end
  
  def assert_inclusion_in(attribute)
    assert_validation_with_message(/must be between 1 and 6/, :value)
  end
  
  def assert_validation_with_message(message, attribute)
    assert ! @model.valid?, "Expected model to be invalid, but it was not"
    assert @model.errors.on(attribute)
    assert_match(message,  
      @model.errors.on(attribute).to_s)
  end
end
