class CreateOrderMailers < ActiveRecord::Migration
  def change
    create_table :order_mailers do |t|

      t.timestamps
    end
  end
end
