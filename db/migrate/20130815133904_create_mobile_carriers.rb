class CreateMobileCarriers < ActiveRecord::Migration
  def change
    create_table :mobile_carriers do |t|

      t.timestamps
    end
  end
end
