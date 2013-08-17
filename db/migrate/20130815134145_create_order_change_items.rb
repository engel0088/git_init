class CreateOrderChangeItems < ActiveRecord::Migration
  def change
    create_table :order_change_items do |t|
      t.integer :order_change_id
      t.integer :monopoly_id
      t.string :operation

      t.timestamps
    end
  end
end
