class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :winner_id
      t.integer :loser_id
      t.date :played_on

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
