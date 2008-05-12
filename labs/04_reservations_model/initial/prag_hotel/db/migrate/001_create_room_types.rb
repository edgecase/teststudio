class CreateRoomTypes < ActiveRecord::Migration
  def self.up
    create_table :room_types do |t|
      t.string :name, :null => false
      t.decimal :rack_rate, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :room_types
  end
end
