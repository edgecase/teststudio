module CommonTestUtilities
  def make_invalid(model, message="so bad")
    flexmock(model, :valid? => false)
    flexmock(model, "errors.full_messages" => [message])
  end

  def make_findable(*args)
    obj = Factory.build(*args)
    flexmock(obj, :id => next_id)
    flexmock(obj.class).
      should_receive(:find).
      with(/#{obj.id}/).
      and_return(obj)
    obj
  end

  RSpec.configure {|c| c.include self}
end
