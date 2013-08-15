class CreateBonus < ActiveRecord::Migration
  def change
    create_table :bonuses, :force => true do |t|
      t.integer :sales_person_id
      t.float :amount
      t.string :note
      t.integer :payment_id

      t.timestamps
    end
  end
end
