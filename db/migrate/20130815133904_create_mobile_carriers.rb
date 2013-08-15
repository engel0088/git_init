class CreateMobileCarriers < ActiveRecord::Migration
  def change
    create_table :mobile_carriers do |t|
      t.string :name
      t.string :domain
      t.string :email_format
      t.integer :digits

    end
  end
end
