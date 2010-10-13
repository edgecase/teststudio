class Player < ActiveRecord::Base
  attr_writer :roller

  has_many :turns

  def roller
    @roller ||= Roller.new
  end
end
