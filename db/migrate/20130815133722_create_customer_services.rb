class CreateCustomerServices < ActiveRecord::Migration
  def change
    create_table :customer_services do |t|

      t.timestamps
    end
  end
end
