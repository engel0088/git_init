class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :type
      t.integer :order_id # for OrderPayment
      t.float :amount
      t.string :method
      t.string :transaction_id
      t.integer :sales_person_id # for CommissionPayment

      t.timestamps
    end
  end
end
