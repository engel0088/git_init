class CreateOrderChanges < ActiveRecord::Migration
  def change
    create_table :order_changes do |t|

      t.timestamps
    end
  end
end
