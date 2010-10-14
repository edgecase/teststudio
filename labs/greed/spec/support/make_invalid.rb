module MakeInvalid
  def make_invalid(model, message="so bad")
    flexmock(model, :valid? => false)
    flexmock(model, "errors.full_messages" => [message])
  end

  RSpec.configure {|c| c.include self}
end
