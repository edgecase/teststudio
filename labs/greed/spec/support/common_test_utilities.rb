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

  # Expect a model to be new'ed with the given attributes.
  def expect_new(model, attrs={})
    klass = attrs.delete(:class) || model.class
    flexmock(model, :id => CommonTestUtilities.next_id)
    flexmock(klass).should_receive(:new).
      with(member_attrs).once.
      and_return(member)
  end

  # Expect a model to be created with the given attributes.
  def expect_creation(model, attrs, invalid=nil)
    klass = attrs.delete(:class) || model.class
    flexmock(model, :id => CommonTestUtilities.next_id)
    flexmock(klass).should_receive(:create).
      with(member_attrs).once.
      and_return(invalid ? nil : member)
    make_invalid(model) if invalid
  end

  # Expect a model to be saved with the given attributes.
  def expect_save(model, invalid=nil)
    flexmock(model, :id => CommonTestUtilities.next_id) if model.id.nil?
    flexmock(model).should_receive(:save).once.
      and_return(invalid ? false : true)
    make_invalid(model) if invalid
  end

  def expect_update(model, attrs, invalid=nil)
    flexmock(model).should_receive(:update_attributes).
      with(attrs).once.
      and_return(invalid ? false : true)
    make_invalid(model) if invalid
  end

  def expect_destruction(model, invalid=nil)
    flexmock(member).should_receive(:destroy).once.and_return(!invalid)
    make_invalid(model) if invalid
  end

  def self.next_id
    @next_id ||= 1000
    @next_id += 1
  end

  RSpec.configure {|c| c.include self}
end
