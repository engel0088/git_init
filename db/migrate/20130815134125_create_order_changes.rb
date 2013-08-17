class CreateOrderChanges < ActiveRecord::Migration
  def change
    create_table :order_changes do |t|
      t.integer :order_id
      t.string :status

      t.timestamps
    end
  end
end
