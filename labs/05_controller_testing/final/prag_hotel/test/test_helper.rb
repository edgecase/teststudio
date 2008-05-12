ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  class << self
    def test_validates_presence_of(field)
      test_name = "test_validates_presence_of_#{field}".to_sym
      define_method test_name do
        assert_validates_presence_of field
      end
    end
    
    def test_validates_numericality_of(field)
      test_name = "test_validates_numericality_of_#{field}".to_sym
      define_method test_name do
        assert_validates_numericality_of field
      end
    end
  end
  
  def assert_validates_presence_of(field)
    @invalid_model = make_model_without(field)
    assert_validation_with_message(/can't be blank/, field)
  end
  
  def assert_validates_numericality_of(field)
    @invalid_model = make_model_with(field => :not_a_number)
    assert_validation_with_message(/is not a number/, field)
  end

  def assert_validates_uniqueness_of(field)
    model_one = make_model_with(field => :duplicate_value)
    @invalid_model = make_model_with(field => :duplicate_value)
    assert_validation_with_message(/has already been taken/, field)
  end

  def assert_validation_with_message(pattern, field)
    model_name = @invalid_model.class
    assert ! @invalid_model.valid?, 
      "Expected #{model_name} to be invalid, but it was not."
    assert @invalid_model.errors.on(field),
      "Expected #{model_name} to have an error on #{field}, but it did not."
    actual_error = @invalid_model.errors.on(field).to_s
    assert_match(pattern, actual_error,
      "Expected #{model_name} to have the error #{pattern}\n Real message was: #{actual_error}")
  end

  private

  def make_model_with(new_options={})
    make_model {|options| options.merge!(new_options)}
  end

  def make_model_without(field)
    make_model {|options| options.delete(field) }
  end
  
  def make_model
    model = model_under_test
    options = model.valid_options
    yield options if block_given?
    model.new options
  end
  
  def model_under_test
    self.class.to_s.gsub('Test', '').constantize
  end

end
