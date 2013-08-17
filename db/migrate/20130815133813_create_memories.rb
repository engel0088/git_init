class CreateMemories < ActiveRecord::Migration
  def change
    create_table :memories do |t|
      t.string :tipe # To not conflict with Rails' type default
      t.string :text

      t.timestamps
    end
  end
end
