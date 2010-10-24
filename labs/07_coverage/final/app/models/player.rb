class Player < ActiveRecord::Base
  belongs_to :game
  has_many :turns
  acts_as_list :scope => :player

  attr_writer :roller

  def roller
    @roller ||= Roller.new
  end
end
