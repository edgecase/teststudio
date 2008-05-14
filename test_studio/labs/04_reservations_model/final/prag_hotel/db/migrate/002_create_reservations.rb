class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.date :check_in
      t.date :check_out
      t.string :name
      t.integer :rate
      t.integer :number_of_rooms
      t.integer :room_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
