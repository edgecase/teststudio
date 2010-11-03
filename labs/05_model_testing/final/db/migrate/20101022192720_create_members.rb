class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.string :email
      t.integer :rank, :default => 1000

      t.timestamps
    end
    add_index :members, [:name], :unique => true
    add_index :members, [:email], :unique => true
  end

  def self.down
    remove_index :members, :email
    remove_index :members, :name
    drop_table :members
  end
end
