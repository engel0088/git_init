class CreateCommissionPayments < ActiveRecord::Migration
  def change
    create_table :commission_payments do |t|

      t.timestamps
    end
  end
end
