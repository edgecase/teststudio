module CommonTestUtilities

  # Make an active record module arbitrarily invalid.  An option error
  # message my be supplied.
  def make_invalid(model, message="arbitrarily invalid")
    flexmock(model, :valid? => false)
    flexmock(model, "errors.full_messages" => [message])
  end

  # Construct an active record object that is findable.  Use the same
  # argument list you would give to a factory girl factory.
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
