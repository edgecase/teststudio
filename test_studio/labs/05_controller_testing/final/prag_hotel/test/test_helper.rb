ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'flexmock/test_unit'
require 'shoulda/rails'

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
    
    def test_validates_uniqueness_of(field)
      test_name = "test_validates_uniqueness_of_#{field}".to_sym
      define_method test_name do
        assert_validates_uniqueness_of field
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
    flexmock(model_under_test).should_receive(:find).and_return(:duplicate_value)
    @invalid_model = make_model_with(field => :duplicate_value)
    assert_validation_with_message(/has already been taken/, field)
  end

  def assert_validation_errors(model, field, pattern=nil)
    model_name = model.class
    model.valid?
    assert model.errors.on(field),
      "Expected #{model_name} to have an error on #{field}, but it did not."
    actual_error = model.errors.on(field).to_s
    if pattern
      assert_match(pattern, actual_error,
        "Expected #{model_name} to have the error #{pattern}\n Real message was: #{actual_error}")
    end
  end

  private

  def make_model_with(model_class, new_options={})
    make_model(model_class) {|options| options.merge!(new_options)}
  end

  def make_model_without(model_class, field)
    make_model(model_class) {|options| options.delete(field) }
  end
  
  def make_model(model_class)
    options = model_class.valid_options
    yield options if block_given?
    model_class.new(options)
  end
end
