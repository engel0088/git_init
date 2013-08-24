class RemoveOrderMailer < ActiveRecord::Migration
  def up
    drop_table :order_mailers
  end

  def down
  end
end
