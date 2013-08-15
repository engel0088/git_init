class CreateMonopolies < ActiveRecord::Migration
  def change
    create_table :monopolies do |t|
      t.integer :zip_code_id
      t.integer :project_type_id
      t.integer :contractor_id
      t.date :expiration

      t.timestamps
    end
    add_index :monopolies, :zip_code_id
    add_index :monopolies, :project_type_id
    add_index :monopolies, :contractor_id

  end
end
