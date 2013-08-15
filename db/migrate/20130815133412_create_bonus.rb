class CreateBonus < ActiveRecord::Migration
  def change
    create_table :bonus do |t|

      t.timestamps
    end
  end
end
