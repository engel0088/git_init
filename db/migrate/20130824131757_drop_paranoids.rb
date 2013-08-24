class DropParanoids < ActiveRecord::Migration
  def up
    drop_table :paranoids
  end

  def down
  end
end
