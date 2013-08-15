class CreateParanoids < ActiveRecord::Migration
  def change
    create_table :paranoids do |t|

      t.timestamps
    end
  end
end
