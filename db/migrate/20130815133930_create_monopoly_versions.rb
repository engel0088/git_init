class CreateMonopolyVersions < ActiveRecord::Migration
  def change
    create_table :monopoly_versions do |t|
      t.integer :monopoly_id
      t.integer :zip_code_id
      t.integer :category_id
      t.integer :contractor_id
      t.date :expiration

      t.timestamps
    end
  end
end
