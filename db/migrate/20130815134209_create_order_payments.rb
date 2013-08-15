class CreateOrderPayments < ActiveRecord::Migration
  def change
    create_table :order_payments do |t|

      t.timestamps
    end
  end
end
