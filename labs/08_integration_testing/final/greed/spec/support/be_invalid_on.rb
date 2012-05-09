module RSpec
  module Matchers
    define :be_invalid_on do |field_name, pattern|
      error_message = ""
      pattern = Regexp.new(Regexp.quote(pattern)) unless pattern.is_a?(Regexp)
      match do |model|
        if model.valid?
          error_message = "Expected model to be invalid, but was valid"
          false
        else
          errors = model.errors[field_name]
          if errors.empty?
            error_message = "Expected errors on field '#{field_name}', but none were found"
            false
          elsif pattern && model.errors[field_name].join(', ') !~ pattern
            error_message = "Expected an error message matching #{pattern}, but got '#{errors.join(', ')}'"
            false
          else
            true
          end
        end
      end

      failure_message_for_should do |model|
        error_message
      end

      failure_message_for_should_not do |model|
        fail "Do not use 'should_not' with be_invalid_on"
      end
    end
  end
end
