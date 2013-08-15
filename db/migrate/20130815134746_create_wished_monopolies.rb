class CreateWishedMonopolies < ActiveRecord::Migration
  def change
    create_table :wished_monopolies do |t|
      t.integer :contractor_id
      t.integer :monopoly_id

      t.timestamps
    end
    add_index :wished_monopolies, :contractor_id
    add_index :wished_monopolies, :monopoly_id

  end
end
