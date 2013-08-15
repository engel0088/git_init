class CreateWishedMonopolies < ActiveRecord::Migration
  def change
    create_table :wished_monopolies do |t|

      t.timestamps
    end
  end
end
