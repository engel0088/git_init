class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :contractor_id
      t.integer :sales_person_id
      t.float :amount
      t.float :discount
      t.float :commission
      t.string :credit_card_number
      t.string :credit_card_expiration
      t.string :credit_card_cvv
      t.datetime :expiration
      t.string :status


      t.timestamps
    end
  end
end
