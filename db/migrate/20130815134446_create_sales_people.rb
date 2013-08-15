class CreateSalesPeople < ActiveRecord::Migration
  def change
    create_table :sales_people do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :login
      t.string :email
      t.string :address
      t.string :city
      t.integer :state_id
      t.string :postal_code, :limit => 5
      t.string :phone, :limit => 15
      t.string :mobile, :limit => 15
      t.string :fax, :limit => 15
      t.integer :commission_rate
      t.integer :contractors_count, :default => 0

      t.timestamps
    end
    add_index :sales_people, :user_id
    add_index :sales_people, :state_id

  end
end
