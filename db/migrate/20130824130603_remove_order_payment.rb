class RemoveOrderPayment < ActiveRecord::Migration
  def up
    drop_table :order_payments
  end

  def down
  end
end
