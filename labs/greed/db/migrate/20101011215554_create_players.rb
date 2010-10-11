class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :type
      t.string :name
      t.integer :game_id
      t.integer :score
      t.string :strategy
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
