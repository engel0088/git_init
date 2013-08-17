class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :name
      t.string :postal_code, :limit => 5
      t.string :phone, :limit => 15
      t.string :email
      t.integer :project_type_id

      t.timestamps
    end

    add_index :leads, :project_type_id
  end
end
