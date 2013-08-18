class AddMobileCarrierToSalesPeople < ActiveRecord::Migration
  def change
    add_column "sales_people", :mobile_carrier_id, :integer
  end
end
