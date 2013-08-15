class CreateMonopolies < ActiveRecord::Migration
  def change
    create_table :monopolies do |t|

      t.timestamps
    end
  end
end
