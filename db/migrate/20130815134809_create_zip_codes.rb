class CreateZipCodes < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.integer :code
      t.string :city
      t.string :state_code, :limit => 2
      t.float :lat
      t.float :lng
      t.integer :elevation

    end
  end
end
