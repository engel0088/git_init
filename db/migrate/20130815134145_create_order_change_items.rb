class CreateOrderChangeItems < ActiveRecord::Migration
  def change
    create_table :order_change_items do |t|

      t.timestamps
    end
  end
end
